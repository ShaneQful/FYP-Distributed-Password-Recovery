require 'sinatra'

set :public_folder, File.dirname(__FILE__) + '/'

get '/' do
  "Hello World #{params[:name]}".strip
end

post '/CrackingInProgress.html' do
  out ="/CrackingInProgress.html?"
  params.each do |k, v|
    out += "#{k}=#{v}&"
  end
  file = File.open("CrackingInProgress.html", "rb")
  out = file.read
end
