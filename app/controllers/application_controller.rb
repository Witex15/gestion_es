class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  before_action :authenticate_person!, unless: :first_user_creation?
  
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
end
