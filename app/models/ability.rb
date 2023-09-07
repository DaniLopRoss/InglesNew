class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role == "administrador"
      can :manage, :all
    elsif user.role == "ingles"
      alias_action :create, :read, :update, :to => :cru
      can :cru, Documento, except: [:destroy, :payment]
      cannot :manage, Payment
      cannot :manage, Certificate
    elsif user.role == "financieros"
      alias_action :create, :read, :update, :to => :cru
      can :cru, Payment, except: [:destroy, :certificate]
      cannot :manage, Documento
      cannot :manage, Certificate
    elsif user.role == "escolares"
      can :read , Payment, except: [:edit, :update, :destroy]
      can :read, Documento, except: [:edit, :update, :destroy]
    elsif user.role == "direccion"
      alias_action :create, :read, :update, :to => :cru
      can :cru, Certificate
    end
  end
end
