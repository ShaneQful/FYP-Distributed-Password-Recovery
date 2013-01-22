require 'rubygems'
require 'sinatra'
require 'json'

set :public_folder, File.dirname(__FILE__) + '/'
# set :files,  File.join(settings.public, 'files')

get '/' do
	redirect '/UploadDialog.html'
end

get '/done.json' do 
	content_type :json
	{ :finished => false, :found => false }.to_json
end

post '/CrackingInProgress.html' do
	unless params[:tocrack] &&
					(tmpfile = params[:tocrack][:tempfile]) &&
					(name = params[:tocrack][:filename])
		@error = "No file selected"
		redirect '/'
	end
	File.open(name, "w") { |f| f.write(tmpfile.read) }
	file = File.open("CrackingInProgress.html", "rb")
	out = file.read
end
