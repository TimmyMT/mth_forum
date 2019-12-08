# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    return guest_abilities unless user
    user.admin? ? admin_abilities : user_abilities
  end

  private

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Post, Comment]
    can :edit, [Post, Comment], user: user
    can :update, [Post, Comment], user: user
    can :destroy, [Post, Comment], user: user
  end

  def admin_abilities
    can :manage, :all
  end
end
