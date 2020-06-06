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
reviews_table = DB.from(:reviews)

before do 
    @current_user = users_table.where(:id => session[:user]).to_a[0]
end

#Home Page (Nick's Local Boston Favorite Places)
get "/" do 
    @places = places_table.all
    view "places"
end 

#Place Page
get "/places/:id" do
    @place = places_table.where(:id => params["id"]).to_a[0]
    @users_table = users_table
    @reviews = reviews_table.where(:place_id => params["id"]).to_a
    @count = reviews_table.where(:place_id => params["id"], :recommend => true).count
    view "place"
end

#Write a Review Page
get "/places/:id/reviews/new" do
    @place = places_table.where(:id => params["id"]).to_a[0]
    view "new_review"
end

#Confirm review submitted
post "/places/:id/reviews/create" do
    reviews_table.insert(:event_id => params["id"],
                       :recommend => params["recommend"],
                       :user_id => @current_user[:id],
                       :comments => params["comments"])
    @event = events_table.where(:id => params["id"]).to_a[0]
    view "create_review"
end 