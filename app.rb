require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
#require 'sqlite3'

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
  erb :index
end

get '/login/form' do
  erb :login_form
end

post '/login/attempt' do
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end

# My code ###

# def init_db
#   @db = SQlite3::Database.new 'leprosorium.sqlite'
#   @db.results_as_hash = true
# end

# before do
#   @init_db
# end

# configure do
#   init_db
#   @db.execute 'CREATE TABLE if not exists Posts (
#   id INTEGER PRIMARY KEY AUTOINCREMENT,
#   created_date DATE,
#   content TEXT
#   );'
# end

get '/new' do
  erb :new
end

post '/new' do
  content = params[:content]

  if content.length == 0
    @error = "Input post text"
    return erb :new
  end

  # save data to database ###

  #@db.execute 'insert into Posts (content, created_date) values (?, datetime())', [content]

  erb "You tiped #{content}"
end
