require 'set'
require 'xxhash'

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
    send("#{strategy}_strategy").take(n)
  end

  private
  #
  # No. 1 strategy developed
  # Will find products that users which liked same products
  # as user we are doing recommendation for
  #
  def naive_strategy
    set = Set.new
    $users_like_products.each do |u|
      set << u[1] if naive_conditions?(u)
    end
    set
  end

  #
  # No. 2 strategy developed
  # Extension to first strategy, where products are paired with
  # number of products both user liked and then sorted accordingly
  #
  # TODO: Benchmark and then use something faster than reduce
  def sorted_naive_strategy
    set = Set.new
    $users_like_products.each do |u|
      set << [u[1], intersection_size(u[0])] if naive_conditions?(u)
    end
    set.sort_by { |n| n[1] }.reverse.map { |n| n[0] }
  end

  #
  # No. 3 strategy developed, after I took a look at the book provided
  #
  # Iterates over users, calculating Jaccard similarity ratio of liked products
  # sorts the result accordingly, flattens it and makes it unique.
  #
  # Thinking about this, I realized that repeated products should pehaps carry
  # greater weight if their Jaccard similarity ratio is close. However,
  # developing it now would take too much time IMHO, since this in not the
  # optiomal solution for large data sets.
  #
  def jaccard_similarity_strategy
    set = Set.new
    $users.each do |u|
      next if u == user
      result = jaccard_result(user.products_liked, u.products_liked)
      set << result unless [1.0, 0.0].include? result[0]
    end
    # Find duplicates
    set.sort_by { |n| n[0] }.reverse.map { |n| n[1].to_a }.flatten.uniq
  end

  #
  # No. 4 strategy
  # MinHash
  #
  def min_hash_strategy
    # Precalculate and store min_hashes
    # This should be recalculated every time user likes a product
    $users.each { |u| u.min_hash = min_hash(u.products_liked) }

    set = Set.new
    # Also, size of the user set taken should be limited (tweaked by experimentation)
    # to something reasonable giving decent enough results
    $users.each do |u|
      set += u.products_liked if user.min_hash == u.min_hash
    end
    set - user.products_liked
  end

  protected

  def min_hash(set)
    hash_min = Float::INFINITY
    set.each do |element|
      element_hash = compute_hash(element)
      hash_min = element_hash if element_hash < hash_min
    end
    hash_min
  end

  def compute_hash(str)
    XXhash.xxh32(str.to_s, 0)
  end

  def naive_conditions?(u)
    u[0] != user.id &&
      intersection_size(u[0]) > 0 &&
      !user.products_liked.include?(u[1])
  end

  def intersection_size(user_id)
    (User.find(user_id).products_liked & user.products_liked).size
  end

  def jaccard_result(s, t)
    u, i = (s | t), (s & t)
    [jaccard(u, i), (t - i)]
  end

  def jaccard(u, i)
    i.size.to_f / u.size.to_f
  end
end
