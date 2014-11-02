require 'set'

class RecommendationEngine
  attr_accessor :user, :products_recommended

  def initialize(user)
    @user = user
    @products_recommended = []
  end

  def self.for(user)
    new(user)
  end

  def recommend(strategy = 'naive', n = 10)
    self.send("#{strategy}_strategy").take(n)
  end

  private

  #
  # No. 1 strategy developed
  # Will find products that users which liked same products
  # as user we are doing recommendation for
  #
  # TODO: Benchmark and then use something faster
  def naive_strategy
    $users_like_products.reduce(Set.new) do |a, e|
      a << e[1] if e[0] != user.id &&
              intersection_size(e[0]) > 0 &&
              !user.products_liked.include?(e[1])
      a
    end
  end

  #
  # No. 2 strategy developed
  # Extension to first strategy, where products are paired with
  # number of products both user liked and then sorted accordingly
  #
  # TODO: Benchmark and then use something faster
  def sorted_naive_strategy
    set = $users_like_products.reduce(Set.new) do |a, e|
      a << [e[1], intersection_size(e[0])] if e[0] != user.id &&
                                              intersection_size(e[0]) > 0 &&
                                              !user.products_liked.include?(e[1])
      a
    end
    set.sort_by { |n| n[1] }.reverse.map { |n| n[0] }
  end

  # No. 3 strategy developed
  # Use hash and index
  def method_name
    set = $users_like_products.reduce({}) do |a, e|
    end
  end

  def intersection_size(user_id)
    (User.find(user_id).products_liked & user.products_liked).size
  end

end
