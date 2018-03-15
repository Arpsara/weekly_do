class ApplicationController < ActionController::Base
  include Pundit

  before_action :authenticate_user!
  after_action :verify_authorized, unless: :devise_controller?
  before_action :calendar_parameter

  protect_from_forgery with: :exception

  def week_number
    Date.today.strftime("%V").to_i
  end
  helper_method :week_number
  alias_method :current_week_number, :week_number

  def calendar_parameter
    @calendar_parameter ||= CalendarParameter.first
  end
end
