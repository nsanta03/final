# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "geocoder"                                                                    #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

places_table = DB.from(:places)
users_table = DB.from(:users)
reviewers_table = DB.from(:reviewers)
# rsvps_table = DB.from(:rsvps)

#before do 
#    @current_user = users_table.where(:id => session[:user]).to_a[0]
#end

#Home Page (Nick's Local Boston Favorite Places)
get "/" do 
    @places = places_table.all
    view "places"
end 

#Place Page
get "/places/:id" do
    @place = places_table.where(:id => params["id"]).to_a[0]
    @users_table = users_table
    @reviewers = reviewers_table.where(:place_id => params["id"]).to_a
    @count = reviewers_table.where(:place_id => params["id"], :recommend => true).count
    view "place"
end