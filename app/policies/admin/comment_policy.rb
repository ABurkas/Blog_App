module Admin
  class CommentPolicy < ApplicationPolicy
    def index?
      user&.admin?
    end

    def destroy?
      user&.admin?
    end
  end
end
