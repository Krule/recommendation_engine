class User
  attr_accessor :id, :products_liked

  def initialize(id)
    @id = id
  end

  def self.find(id)
    $users.find { |user| user.id == id } || $users << new(id) && $users.last
  end

  def products_liked
    @products_liked ||= $users_like_products.reduce(Set.new) do |a, e|
      a << e[1] if e[0] == id
      a
    end
  end
end
