# Typical example using standard RSpec dsl
require "json" #TODO: REMOVE
require "selenium-webdriver"
require "axe/core"
require "axe/api/run"
$driver = Selenium::WebDriver.for :firefox

def run_axe
  Axe::Core.new($driver).call Axe::API::Run.new
end

$fixture_root = File.join __dir__, "..", "..", "..", "..", "..", "node_modules", "axe-test-fixtures", "fixtures"
axe_pre_43x_file = File.join $fixture_root, "axe-core@legacy.js"
$axe_pre_43x = File.read axe_pre_43x_file
$axe_post_43x = Axe::Configuration.instance.jslib
$crasher_js = File.read File.join($fixture_root, "axe-crasher.js")
$force_legacy_js = File.read File.join($fixture_root, "axe-force-legacy.js")

def fixture(filename)
  "http://localhost:8000" + filename
end

def with_js(axe_source)
  Axe::Configuration.instance.jslib = axe_source
  ret = yield
  Axe::Configuration.instance.jslib = $axe_post_43x
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
  it "injects into nested iframes" do
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
  it "can run" do
    $driver.get fixture "/nested-iframes.html"
    res = with_js($axe_pre_43x) { run_axe }

    expect(res.results.testEngine["version"]).to eq "4.0.3"

    label_vio = res.results.violations.find { |vio| vio.id == :label }
    expect(label_vio).not_to be_nil
    expect(label_vio.nodes.length).to be 4
  end

  it "throws if the top level errors" do
    $driver.get fixture "/crash.html"
    with_js($axe_pre_43x + $crasher_js) {
      expect { run_axe }.to raise_error /Boom!/
    }
  end

  it "reports frame-tested" do
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


describe "run vs runPartial" do
  it "should return the same results" do
    $driver.get fixture "/nested-iframes.html"
    legacy_res = with_js($axe_post_43x + $force_legacy_js) { run_axe }
    expect(legacy_res.results.testEngine["name"]).to eq "axe-legacy"

    $driver.get fixture "/nested-iframes.html"
    normal_res = with_js($axe_post_43x) { run_axe }
    normal_res.results.timestamp = legacy_res.results.timestamp
    normal_res.results.testEngine["name"] = legacy_res.results.testEngine["name"]

    expect(recursive_compact(normal_res.results.to_h)).to eq recursive_compact(legacy_res.results.to_h)
  end
end
