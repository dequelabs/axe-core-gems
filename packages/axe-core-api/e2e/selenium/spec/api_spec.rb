# Typical example using standard RSpec dsl
require "json" #TODO: REMOVE
require "selenium-webdriver"
require "axe/core"
require "axe/api/run"

options = Selenium::WebDriver::Firefox::Options.new
options.add_argument('--headless')
$driver = Selenium::WebDriver.for :firefox, options: options
$driver.manage.timeouts.implicit_wait = 300
$driver.manage.timeouts.script_timeout = 300

Run = Axe::API::Run

def run_axe(run = Run.new)
  Axe::Core.new($driver).call run
end

$fixture_root = File.join __dir__, "..", "..", "..", "..", "..", "node_modules", "axe-test-fixtures", "fixtures"
axe_pre_43x_file = File.join $fixture_root, "axe-core@legacy.js"
$axe_pre_43x = File.read axe_pre_43x_file
$axe_post_43x = Axe::Configuration.instance.jslib
$crasher_js = File.read File.join($fixture_root, "axe-crasher.js")
$force_legacy_js = File.read File.join($fixture_root, "axe-force-legacy.js")
$large_partial_js = File.read File.join($fixture_root, "axe-large-partial.js")

def fixture(filename)
  "http://localhost:8000" + filename
end

def with_js(axe_source)
  Axe::Configuration.instance.jslib = axe_source
  ret = yield
  Axe::Configuration.instance.jslib = $axe_post_43x
  ret
end

def with_legacy_mode
  Axe::Configuration.instance.legacy_mode = true
  ret = yield
  Axe::Configuration.instance.legacy_mode = nil
  ret
end

# The ruby selenium driver differentiates between a JS property on an object being
# `undefined` and not existing at all (e.g. the property `shadowColor` in `{color: 'red'}` vs `{color: 'red', shadowColor: undefined}`).
# When using `run` the axe-core inter-frame messaging removes the `{shadowColor: undefined}`
# so that we don't even see them in ruby world.
# `runPartail` on the other hand correctly gives us the `undefined` property (converted into `None`).
# Since we don't use the difference between `undefined` and `null` in axe-core (both are converted into `None`),
# just remove all `None`s so the `undefined` vs non-existent difference is removed.
# https://stackoverflow.com/a/65082546
def recursive_compact(thing)
  if thing.is_a?(Array)
    thing.each_with_object([]) do |v, a|
      v = recursive_compact(v)
      a << v unless [nil, [], {}].include?(v)
    end
  elsif thing.is_a?(Hash)
    thing.each_with_object({}) do |(k,v), h|
      v = recursive_compact(v)
      h[k] = v unless [nil, [], {}].include?(v)
    end
  else
    thing
  end
end

describe "Crashes" do
  it "throws if axe errors out on the top window" do
    $driver.get fixture "/crash.html"
    with_js($axe_post_43x + $crasher_js) {
      expect { run_axe }.to raise_error /Boom!/ 
    }
  end

  it "throws when injecting a problematic source" do
    $driver.get fixture "/crash.html"
    with_js("throw new Error('BOOOM')") {
      expect { run_axe }.to raise_error /BOOOM/
    }
  end

  it "throws when a setup fails" do
    $driver.get fixture "/index.html"
    with_js($axe_post_43x + ";window.axe.utils = {}") {
      expect { run_axe }.to raise_error /is not a function/
    }
  end

  it "isolates axe.finishRun" do
    $driver.get fixture "/isolated-finish.html"
    expect { run_axe }.not_to raise_error
  end
end

describe "frame tests" do
  it "injects into nested iframes", :fo => true do
    $driver.get fixture "/nested-iframes.html"
    res = run_axe
    expect(res.results.violations).not_to be_empty
    label_vio = res.results.violations.find { |vio| vio.id == :label }
    expect(label_vio).not_to be_nil
    expect(label_vio.nodes.length).to be 4
    expect(label_vio.nodes[0].target).to contain_exactly(
      "#ifr-foo",
      "#foo-bar",
      "#bar-baz",
      "input"
    )
    expect(label_vio.nodes[1].target).to contain_exactly(
      "#ifr-foo",
      "#foo-baz",
      "input"
    )
    expect(label_vio.nodes[2].target).to contain_exactly(
      "#ifr-bar",
      "#bar-baz",
      "input"
    )
    expect(label_vio.nodes[3].target).to contain_exactly(
      "#ifr-baz",
      "input"
    )
  end

  it "injects into nested frameset" do
    $driver.get fixture "/nested-frameset.html"
    res = run_axe
    expect(res.results.violations).not_to be_empty
    label_vio = res.results.violations.find { |vio| vio.id == :label }
    expect(label_vio).not_to be_nil
    expect(label_vio.nodes.length).to be 4
    expect(label_vio.nodes[0].target).to contain_exactly(
      "#frm-foo",
      "#foo-bar",
      "#bar-baz",
      "input"
    )
    expect(label_vio.nodes[1].target).to contain_exactly(
      "#frm-foo",
      "#foo-baz",
      "input"
    )
    expect(label_vio.nodes[2].target).to contain_exactly(
      "#frm-bar",
      "#bar-baz",
      "input"
    )
    expect(label_vio.nodes[3].target).to contain_exactly(
      "#frm-baz",
      "input"
    )
  end

  it "should work on shadow DOM iframes" do
    $driver.get fixture "/shadow-frames.html"
    res = run_axe
    expect(res.results.violations).not_to be_empty
    label_vio = res.results.violations.find { |vio| vio.id == :label }
    expect(label_vio).not_to be_nil
    expect(label_vio.nodes.length).to be 3
    expect(label_vio.nodes[0].target).to contain_exactly(
      "#light-frame",
      "input"
    )
    expect(label_vio.nodes[1].target).to contain_exactly(
      ["#shadow-root", "#shadow-frame"],
      "input"
    )
    expect(label_vio.nodes[2].target).to contain_exactly(
      "#slotted-frame",
      "input"
    )
  end
  it "reports erroring frames in frame-tested" do
    $driver.get fixture "/crash-parent.html"
    res = with_js($axe_post_43x + $crasher_js) { run_axe }
    expect(res.results.violations).not_to be_empty

    ft_inc = res.results.incomplete.find { |inc| inc.id == :'frame-tested' }
    expect(ft_inc).not_to be_nil
    expect(ft_inc.nodes.length).to be 1
    expect(ft_inc.nodes[0].target).to contain_exactly(
      "#ifr-crash"
    )

    label_vio = res.results.violations.find { |vio| vio.id == :label }
    expect(label_vio).not_to be_nil
    expect(label_vio.nodes.length).to be 2
    expect(label_vio.nodes[0].target).to contain_exactly(
      "#ifr-bar",
      "#bar-baz",
      "input"
    )
    expect(label_vio.nodes[1].target).to contain_exactly(
      "#ifr-baz",
      "input"
    )
  end
end

describe "for versions without axe.runPartial" do
  it "can run", :oldaxe => true do
    $driver.get fixture "/nested-iframes.html"
    res = with_js($axe_pre_43x) { run_axe }

    expect(res.results.testEngine["version"]).to eq "4.2.3"

    label_vio = res.results.violations.find { |vio| vio.id == :label }
    expect(label_vio).not_to be_nil
    expect(label_vio.nodes.length).to be 4
  end

  it "throws if the top level errors", :oldaxe => true do
    $driver.get fixture "/crash.html"
    with_js($axe_pre_43x + $crasher_js) {
      expect { run_axe }.to raise_error /Boom!/
    }
  end

  it "reports frame-tested", :oldaxe => true do
    $driver.get fixture "/crash-parent.html"
    res = with_js($axe_pre_43x + $crasher_js) { run_axe }

    ft_inc = res.results.incomplete.find { |inc| inc.id == :'frame-tested' }
    expect(ft_inc).not_to be_nil
    expect(ft_inc.nodes.length).to be 1

    label_vio = res.results.violations.find { |vio| vio.id == :label }
    expect(label_vio).not_to be_nil
    expect(label_vio.nodes.length).to be 2
  end
end

describe "metadata" do
  it "returns correct results metadata" do
    $driver.get fixture "/index.html"
    res = run_axe
    expect(res.results.testEngine["name"]).not_to be_nil
    expect(res.results.testEngine["version"]).not_to be_nil

    expect(res.results.testEnvironment["orientationAngle"]).not_to be_nil
    expect(res.results.testEnvironment["orientationType"]).not_to be_nil
    expect(res.results.testEnvironment["userAgent"]).not_to be_nil
    expect(res.results.testEnvironment["windowHeight"]).not_to be_nil
    expect(res.results.testEnvironment["windowWidth"]).not_to be_nil

    expect(res.results.testRunner["name"]).not_to be_nil

    expect(res.results.toolOptions["reporter"]).not_to be_nil

    expect(res.results.url).to eq(fixture "/index.html")
  end
end

describe "axe.finishRun" do
  window_open_throws = ";window.open = () => { throw new Error('No window.open')}"
  finish_run_throws = ";axe.finishRun = () => { throw new Error('No finishRun')}"

  it "throws an error if window.open throws" do
    $driver.get fixture "/index.html"
    with_js($axe_post_43x + window_open_throws) {
      expect { run_axe }.to raise_error /switchToWindow failed/
    }
  end

  it "throws an error if axe.finishRun throws" do
    $driver.get fixture "/index.html"
    with_js($axe_post_43x + finish_run_throws) {
      expect { run_axe }.to raise_error /finishRun failed/
    }
  end

  it "works with large results", :nt => true do
    $driver.get fixture "/index.html"
    res = with_js($axe_post_43x + $large_partial_js) { run_axe }


    expect(res.results.passes.length).to eq 1
    expect(res.results.passes[0].id).to eq :'duplicate-id'
  end
end


describe "run vs runPartial" do
  it "should return the same results" do
    $driver.get fixture "/nested-iframes.html"
    legacy_res = with_js($axe_post_43x + $force_legacy_js) { run_axe }
    expect(legacy_res.results.testEngine["name"]).to eq "axe-legacy"

    $driver.get "about:blank"
    $driver.get fixture "/nested-iframes.html"
    normal_res = with_js($axe_post_43x) { run_axe }
    normal_res.results.timestamp = legacy_res.results.timestamp
    normal_res.results.testEngine["name"] = legacy_res.results.testEngine["name"]

    expect(recursive_compact(normal_res.results.to_h)).to eq recursive_compact(legacy_res.results.to_h)
  end
end

describe "4.6 selectors" do
  def flat_targets(rules)
    targets = []
    rules.each do |rule|
      rule.nodes.each do |node|
        node["target"].each do |target|
          if target.is_a? Array
            targets.concat target
          else
            targets.append target
          end
        end
      end
    end

    targets
  end

  it "with labelled frame", :newt => true do
    $driver.get fixture "/context-include-exclude.html"

    run = Run.new
        .within({ "fromFrames" => ["#ifr-inc-excl", "html"] })
        .excluding({ "fromFrames" => ["#ifr-inc-excl", "#foo-bar"] })
        .within({ "fromFrames" => ["#ifr-inc-excl", "#foo-baz", "html"] })
        .excluding({ "fromFrames" => ["#ifr-inc-excl", "#foo-baz", "input"] })
    res = run_axe run

    label_result = res.results.violations.find {|rule| rule.id == :label}

    targets = flat_targets res.results.passes
    expect(targets).not_to include "#foo-bar"
    expect(targets).not_to include "input"
    expect(label_result).to be_nil
  end

  it "with include shadow DOM" do
    $driver.get fixture "/shadow-dom.html"

    run = Run.new
      .within([["#shadow-root-1", "#shadow-button-1"]])
      .within([["#shadow-root-2", "#shadow-button-2"]])
    res = run_axe run

    targets = flat_targets res.results.passes
    expect(targets).to include "#shadow-button-1"
    expect(targets).to include "#shadow-button-2"
    expect(targets).not_to include "#button"
  end

  it "with exclude shadow DOM" do
    $driver.get fixture "/shadow-dom.html"

    run = Run.new
      .excluding([["#shadow-root-1", "#shadow-button-1"]])
      .excluding([["#shadow-root-2", "#shadow-button-2"]])
    res = run_axe run

    targets = flat_targets res.results.passes
    expect(targets).not_to include "#shadow-button-1"
    expect(targets).not_to include "#shadow-button-2"
    expect(targets).to include "#button"
  end

  it "with labelled shadow DOM" do
    $driver.get fixture "/shadow-dom.html"

    run = Run.new
      .within({ "fromShadowDom" => ["#shadow-root-1", "#shadow-button-1"] })
      .excluding({ "fromShadowDom" => ["#shadow-root-2", "#shadow-button-2"] })
    res = run_axe run

    targets = flat_targets res.results.passes
    expect(targets).to include "#shadow-button-1"
    expect(targets).not_to include "#shadow-button-2"
  end

  it "with labelled iframe and shadow DOM" do
    $driver.get fixture "/shadow-frames.html"

    run = Run.new
      .with_options({ "runOnly" => "label"})
      .excluding({
            "fromFrames" => [{
                "fromShadowDom" => ["#shadow-root", "#shadow-frame"]
              },
              "input"
            ]
          })
    res = run_axe run

    expect(res.results.violations[0].id).to eq :label
    expect(res.results.violations[0].nodes.length).to eq 2

    nodes = res.results.violations[0].nodes
    expect(nodes[0].target).to eq ["#light-frame", "input"]
    expect(nodes[1].target).to eq ["#slotted-frame", "input"]
  end
end

describe "legacy_mode" do
  run_partial_throws = ";axe.runPartial = () => { throw new Error('No runPartial')}"

  it "runs legacy mode when used" do
    $driver.get fixture "/external/index.html"
    res = with_legacy_mode {
      with_js($axe_post_43x + run_partial_throws) {
        run_axe
      }
    }
    expect(res).not_to be_nil
  end

  it "prevents cross-origin frame testing" do
    $driver.get fixture "/cross-origin.html"
    res = with_legacy_mode {
      with_js($axe_post_43x + run_partial_throws) {
        run_axe
      }
    }

    ft_inc = res.results.incomplete.find { |inc| inc.id == :'frame-tested' }
    expect(ft_inc).not_to be_nil
  end

  it "can be disabled again" do
    $driver.get fixture "/cross-origin.html"
    res = with_legacy_mode {
      Axe::Configuration.instance.legacy_mode = nil
      run_axe
    }
    expect(res).not_to be_nil
    ft_inc = res.results.incomplete.find { |inc| inc.id == :'frame-tested' }
    expect(ft_inc).to be_nil
  end

  describe "allowedOrigin" do
    def get_allowed_origin
      return $driver.execute_script("return axe._audit.allowedOrigins")
    end

    it "should not set when running runPartial and not legacy mode" do
      $driver.get fixture "/index.html"
      run_axe
      allowed_origin = get_allowed_origin
      expect(allowed_origin).to eq ["http://localhost:8000"]
      expect(allowed_origin.length).to eq 1
    end

    it "should set when running runPartial and legacy mode" do
      $driver.get fixture "/index.html"
      with_legacy_mode { run_axe }
      allowed_origin = get_allowed_origin
      expect(allowed_origin).to eq ["http://localhost:8000"]
      expect(allowed_origin.length).to eq 1
    end

    it "should not set when running legacy source and legacy mode" do
      $driver.get fixture "/index.html"
      with_legacy_mode {
        with_js($axe_pre_43x) {
          run_axe
        }
      }
      allowed_origin = get_allowed_origin
      expect(allowed_origin).to eq ["http://localhost:8000"]
      expect(allowed_origin.length).to eq 1
    end

    it "should set when running legacy source and not legacy mode" do
      $driver.get fixture "/index.html"
      with_js($axe_pre_43x) { run_axe }
      allowed_origin = get_allowed_origin
      expect(allowed_origin).to eq ["*"]
      expect(allowed_origin.length).to eq 1
    end
  end
end
