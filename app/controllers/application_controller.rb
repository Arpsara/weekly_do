class ApplicationController < ActionController::Base
  include Pundit

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :verify_authorized, unless: :devise_controller?

  before_action :calendar_parameter, unless: :devise_controller?
  before_action :masquerade_user!

  protect_from_forgery with: :exception

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
      keys:
        [
          :email, :password, :password_confirmation, :firstname, :lastname
        ]
    )
  end

  def week_number(week_number = nil)
    if week_number
      week_number.to_i
    else
      Date.today.strftime("%V").to_i
    end
  end
  helper_method :week_number
  alias_method :current_week_number, :week_number

  def calendar_parameter
    @calendar_parameter ||=  current_user.calendar_parameter if user_signed_in?
  end

  def current_user_timer
    if current_user
      uncompleted_time_entries = current_user.time_entries.where(current: true)
      reset_current_timers(uncompleted_time_entries) unless @already_reset
      unless uncompleted_time_entries.any?
        @timer_start_at = 0
        #TimeEntry.create(start_at: Time.now, user_id: current_user.id, spent_time: 0, current: true)
      end
      uncompleted_time_entries.reload.first
    end
  end
  helper_method :current_user_timer

  def timer_start_at
    if current_user_timer && !current_user_timer.in_pause
      @timer_start_at ||= ((Time.now.utc - current_user_timer.start_at.try(:utc))).round
    else
      @timer_start_at ||= current_user_timer.spent_time * 60
    end
    return @timer_start_at
  end

  def reset_current_timers(uncompleted_time_entries)
    uncompleted_time_entries.where.has{(start_at <= Date.today)}.each do |time_entry|
      time_entry.update_attributes(current: false)
    end
    @already_reset = true
  end

  def title(title, params)
    if @title
      title = "- #{@title}"
    else
      files = Dir[Rails.root + 'app/models/*.rb']
      models = files.map{ |m| File.basename(m, '.rb').camelize }

      if models.include?(params[:controller].split('/').last.classify)
        model = Object.const_get(params[:controller].split('/').last.classify)
      end
      if model
        title = "- " + Object.const_get(params[:controller].split('/').last.classify).model_name.human + " - " + t("words.#{params[:action]}")
      end
    end
  end
  helper_method :title

  def charts_mode?
    params[:mode] == "charts"
  end
  helper_method :charts_mode?

  def gon_for_tasks_modals
    {
      project_categories_url: admin_project_categories_path,
      project_kanbans_url: kanban_admin_project_path(id: :id),
      update_time_entry: admin_update_time_entry_path(id: current_user_timer.try(:id) || :id),
      show_modal_url: admin_show_modal_path
    }
  end
end
