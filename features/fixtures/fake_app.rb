require "sinatra"
require "slim"

module RSpecA11ySteps
  class FakeApp < Sinatra::Application

    get '/' do
      slim :index
    end

    # start the server if ruby file executed directly
    run! if app_file == $0
  end
end
