class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
    #

    user ||= User.new

    if user.admin?
      can [:create, :read, :destroy], User
      cannot :destroy, User, :id => user.id 
      cannot :destroy, User do |user| 
        user.program_users.any?
      end
      can :manage, Site
      can :manage, Program
      can :manage, ProgramUser
      can [:manage, :edit_fields], Week
    end

    can :read, Site

    can [:read], Program do |program|
      user.programs.include? program
    end

    can :update, Week do |week|
      user.site_director_for? week.program
    end

    can [:read, :update], User do |read_user|
      read_user == user 
    end

  end
end
