require 'csv'
require 'set'

# Global variables are used to represent external storage
$users = []
$users_like_products = Set.new CSV.read('user_products.csv', converters: :numeric).to_a[1..-1]

require_relative 'lib/user'
require_relative 'lib/recommendation'
require_relative 'lib/recommendation_engine'

user = User.find(1)
p RecommendationEngine.for(user).recommend!
