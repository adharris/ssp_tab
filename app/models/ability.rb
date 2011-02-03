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
      can [:create, :read, :destroy, :create_admin], User
      cannot :destroy, User, :id => user.id 
      cannot :destroy, User do |user| 
        user.program_users.any?
      end
      can :manage, Site
      can :see_vendors_for, Site
      can :manage, Program
      can :manage, ProgramUser
      can [:manage, :edit_fields], Week
      can :manage, Vendor
      can :manage, Purchase
      can :manage, FoodItem
    else

      unless user.current_program.nil?
        can :read, Site
        can :see_vendors_for, Site, :id => user.current_program.site.id
        can [:read], Program, :id => user.current_program.id

        if user.current_job == "Site Director"
          can :update, Week, :program_id => user.current_program.id
        end

        can [:read, :update, :create], Vendor, :site_id => user.current_program.site.id
        can [:read], FoodItem, :program_id => nil
        can [:manage], FoodItem, :program_id => user.current_program.id

        can [:read, :update, :create], Purchase, :program_id => user.current_program.id

      end
    end

    can [:read, :update], User do |read_user|
      read_user == user 
    end

  end
end
