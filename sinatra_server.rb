require 'rubygems'
require 'sinatra'
require 'json'
require 'Scripts/master_run.rb'

files = []

set :public_folder, File.dirname(__FILE__) + '/'
# set :files,  File.join(settings.public, 'files')

get '/' do
	redirect '/UploadDialog.html'
end

get '/done.json' do 
	content_type :json
	filename = files[-1]
	output_files = bash "cat ~/#{$results_folder}/#{filename}/* | grep :"
	if(!output_files.empty?)
		password = grab_password(output_files)
		{ :finished => true, :found => true, :password => password }.to_json
	else
		{ :finished => false, :found => false }.to_json
	end
end

post '/CrackingInProgress.html' do
	unless params[:tocrack] &&
					(tmpfile = params[:tocrack][:tempfile]) &&
					(name = params[:tocrack][:filename])
		@error = "No file selected"
		redirect '/'
	end
	doc_format = params[:type]
	#Need pis file in WebUI too
# 	Thread.new {run_attack "~/WebUI/#{name}", doc_format}
	Open3.popen3 "ruby Scripts/master_run.rb ~/WebUI/#{name} #{doc_format}"
	File.open(name, "w") { |f| f.write(tmpfile.read) }
	files.push name
	file = File.open("CrackingInProgress.html", "rb")
	out = file.read
end
