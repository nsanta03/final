# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :places do
  primary_key :id
  String :title
  String :description, text: true
  String :location
end
DB.create_table! :reviews do
  primary_key :id
  foreign_key :place_id
  foreign_key :user_id
  Boolean :recommend
  String :comments, text: true
end
DB.create_table! :users do
  primary_key :id
  String :name
  String :hometown
  String :email
  String :password
end

# Insert initial (seed) data
places_table = DB.from(:places)

places_table.insert(title: "Fenway Park", 
                    description: "Visit America's most famous ballpark! Get tickets to a Red Sox game and come early to explore Yawkey Way. Stay after the game for drinks and live music on Boylston Street.",
                    location: "4 Jersey Street, Boston, MA 02215")

places_table.insert(title: "Mike's Pastry", 
                    description: "The best Italian pastries in Boston's classic North End! No trip to Boston is complete without a stop at Mike's.",
                    location: "300 Hanover Street, Boston, MA 02113")
                    
places_table.insert(title: "Legal Harborside", 
                    description: "Rooftop views of the harbor and some of the best seafood in Boston! When you're done, take a walk and check out the swanky bars in this up and coming neighborhood.",
                    location: "270 Northern Avenue, Boston, MA 02210")                    

places_table.insert(title: "Gourmet Dumpling House", 
                    description: "The best soup dumplings (xiao long bao) on the East Coast! Get here early and expect to wait for a table at this authentic classic spot.",
                    location: "52 Beach Street, Boston, MA 02111")   