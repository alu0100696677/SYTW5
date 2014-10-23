#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'uri'
require 'pp'
#require 'socket'
require 'data_mapper'
require 'omniauth-oauth2'
require 'omniauth-google-oauth2'
require 'pry'
require 'erubis'

use OmniAuth::Builder do
  config = YAML.load_file 'config/config.yml'
  provider :google_oauth2, config['identifier'], config['secret']
end

enable :sessions
set :sessions_secret, '*&(^#234a)'

DataMapper.setup( :default, ENV['DATABASE_URL'] || 
                            "sqlite3://#{Dir.pwd}/my_shortened_urls.db" )
DataMapper::Logger.new($stdout, :debug)
DataMapper::Model.raise_on_save_failure = true 

require_relative 'model'

DataMapper.finalize

#DataMapper.auto_migrate!
DataMapper.auto_upgrade!

Base = 36
<<<<<<< HEAD

get '/' do
  puts "inside get '/': #{params}"
  @list = ShortenedUrl.all(:order => [ :id.asc ], :limit => 20)
  # in SQL => SELECT * FROM "ShortenedUrl" ORDER BY "id" ASC
  haml :index
=======
$email = "ejemplo@example"

get '/' do

	if @auth then
		begin
		redirect '/auth/failure'
		end
		else
		%Q|<a href= '/auth/google_oauth2'>Identificarse con Google</a></BR><a href='/auth/failure'>No identificarse con Google</a>|
		end|

	end
	
	get '/auth/:name/callback' do
		@auth = request.env['omniauth.auth']
		$email = @auth['info'].email
		if @auth then
		begin
			puts "inside get '/': #{params}"
			@list = ShortenedUrl.all(:order => [ :id.asc ], :limit => 20, :id_usu => $email)
			# in SQL => SELECT * FROM "ShortenedUrl" ORDER BY "id" ASC
			haml :index
		end
		else
			redirect '/auth/failure'
		end
		
	end

end

get '/auth/failure' do
	
	puts "inside get '/': #{params}"
	@list = ShortenedUrl.all(:order => [ :id.asc ], :limit => 20, :id_usu => " ")

	haml :index
>>>>>>> belen
end

post '/' do
  puts "inside post '/': #{params}"
  uri = URI::parse(params[:url])
  if uri.is_a? URI::HTTP or uri.is_a? URI::HTTPS then
    begin
<<<<<<< HEAD
      @short_url = ShortenedUrl.first_or_create(:url => params[:url])
=======
	if params[:to] == ""
		@short_url = ShortenedUrl.first_or_create(:url => params[:url], :id_usu => $email)
	else
		@short_url = ShortenedUrl.first_or_create(:url => params[:url], :to => params[:to], :id_usu => $email)
	end
>>>>>>> belen
    rescue Exception => e
      puts "EXCEPTION!!!!!!!!!!!!!!!!!!!"
      pp @short_url
      puts e.message
    end
  else
    logger.info "Error! <#{params[:url]}> is not a valid URL"
  end
  redirect '/'
end

get '/:shortened' do
  puts "inside get '/:shortened': #{params}"
  short_url = ShortenedUrl.first(:id => params[:shortened].to_i(Base))
<<<<<<< HEAD

=======
  to_url = ShortenedUrl.first(:to => params[:shortened])
>>>>>>> belen
  # HTTP status codes that start with 3 (such as 301, 302) tell the
  # browser to go look for that resource in another location. This is
  # used in the case where a web page has moved to another location or
  # is no longer at the original location. The two most commonly used
  # redirection status codes are 301 Move Permanently and 302 Found.
<<<<<<< HEAD
  redirect short_url.url, 301
=======
  
  if to_url
	redirect to_url.url, 301
  else
	redirect short_url.url, 301
  end

>>>>>>> belen
end

error do haml :index end
