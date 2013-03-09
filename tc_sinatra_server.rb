require_relative 'sinatra_server.rb'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class ServerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_serves_upload_dialog
    get '/'
    assert last_response.should be_redirect, 'No redirecting'
  end

  def test_cracking_dialog_redirect
    get '/CrackingInProgress.html'
    assert last_response.should be_redirect, 'No redirecting'
  end
end