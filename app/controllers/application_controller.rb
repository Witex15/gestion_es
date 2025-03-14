class ApplicationController < ActionController::Base
  # Include Pundit for authorization
  include Pundit::Authorization
  
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  before_action :authenticate_person!, unless: :first_user_creation?
  
  # Prevent CSRF attacks by raising an exception
  protect_from_forgery with: :exception
  
  # Global Pundit user
  def pundit_user
    current_person
  end
  
  private
  
  def require_teacher_or_dean
    unless current_person.teacher? || current_person.dean?
      flash[:alert] = "You are not authorized to perform that action."
      redirect_to root_path
    end
  end

  def first_user_creation?
    Person.count.zero? && 
      controller_name == 'people' && 
      ['new', 'create'].include?(action_name)
  end
  
  # Global error handling for Pundit authorization errors
  rescue_from Pundit::NotAuthorizedError do |exception|
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
