require 'recommendation_engine'
require 'user'

describe RecommendationEngine do
  context 'user recommendation' do
    context 'naive strategy' do
      before do
        user = User.find(1)
        @recommendations = RecommendationEngine.for(user).recommend
      end

      it 'contains expected product ids' do
        expect(@recommendations).to include(7, 56, 78, 90, 121)
      end

      it 'does not contains already liked product ids' do
        expect(@recommendations).not_to include(1, 2, 3, 25)
      end

      it 'contains 10 or less products (default)' do
        expect(@recommendations.size).to be <= 10
      end
    end

    context 'sorted naive strategy' do

      before do
        user = User.find(1)
        @recommendations = RecommendationEngine.for(user)
                                               .recommend(:sorted_naive)
      end

      it 'contains expected product ids' do
        expect(@recommendations).to include(23, 42, 63, 7, 5)
      end

      it 'does not contains already liked product ids' do
        expect(@recommendations).not_to include(1, 2, 3, 25)
      end

      it 'contains 10 or less products (default)' do
        expect(@recommendations.size).to be <= 10
      end
    end
  end
end
