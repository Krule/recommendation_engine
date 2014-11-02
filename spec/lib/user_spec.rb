require 'user'

describe User do

  context 'products liked' do

    before { @user = User.find(1) }

    it 'contains expected product ids' do
      expect(@user.products_liked).to include(1, 2, 3, 25)
    end

    it 'does not contain unexpected product ids' do
      expect(@user.products_liked).not_to include(56, 5, 7)
    end
  end
end
