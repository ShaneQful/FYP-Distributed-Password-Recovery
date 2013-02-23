require 'rubygems'
require 'sinatra'
require 'json'
require_relative 'Scripts/master_run.rb'

files = []
cracking_speeds = { "office" => 6.3, "odf" => 155, "sxc" => 155, "pdf" => 5281 }
dictionary_size = { "inbuilt" => 3917193, "unix" => 99171 }

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
	#Need pis file in WebUI too
	#Thread.new {run_attack "~/WebUI/#{name}", doc_format}
	run_attack = "ruby Scripts/master_run.rb ~/WebUI/#{name} #{params[:type]} "
	run_attack += "#{params[:dict]} #{request.ip}"
	Open3.popen3 run_attack
	File.open(name, "w") { |f| f.write(tmpfile.read) }
	files.push name
	file = File.open("CrackingInProgress.html", "rb")
	out = file.read
	calc_per_sec = cracking_speeds[params[:type]]*9
	out = out.gsub(/CALC_PER_SEC/, calc_per_sec.to_s)
	out = out.gsub(/DICTIONARY_SIZE/, dictionary_size[params[:dict]].to_s)
	out
end
