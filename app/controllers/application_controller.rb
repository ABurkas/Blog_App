include Pundit

class ApplicationController < ActionController::Base
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "Nie masz uprawnień do wykonania tej akcji."
    redirect_to(request.referrer || root_path)
  end
end
