require 'simplecov'
SimpleCov.start

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
		follow_redirect!
		assert last_response.body.include?('src="upload.js"'), 'Upload dialog not serving'
	end

	def test_json_request
		get '/done.json'
		assert last_response.content_type.include?('json'), 'Not JSON Reponse'
	end
# 	def test_it_serves_cracking_dialog
# 		post '/CrackingInProgress.html'
# 		follow_redirect!
# 		puts last_response.ok?
# 		assert last_response.body.include?('src="upload.js"'), 'Cracking dialog not serving'
# 	end
end