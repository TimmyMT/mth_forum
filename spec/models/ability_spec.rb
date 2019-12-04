require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Category }
    it { should be_able_to :read, Post }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    let!(:category) { Category.create!(name: 'TestCategory') }
    let!(:post) { create(:post, category: category, user: user) }
    let!(:post_other_user) { create(:post, category: category, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Post' do
      it { should be_able_to :create, Post }

      it { should be_able_to :update, post, user: user }
      it { should_not be_able_to :update, post_other_user, user: user }

      it { should be_able_to :destroy, post, user: user }
      it { should_not be_able_to :destroy, post_other_user, user: user }
    end
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end
end
