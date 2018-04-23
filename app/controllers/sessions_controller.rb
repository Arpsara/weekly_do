class SessionsController < Devise::SessionsController
  include TimeHelper

  def sign_out
    if current_user_timer && current_user_timer.in_pause == false
      new_spent_time = convert_in_minutes( ((Time.now.to_f - current_user_timer.start_at.to_f) / 60 / 60).to_s )

      spent_time = current_user_timer.spent_time + new_spent_time
      current_user_timer.update_attributes(in_pause: true, end_at: Time.now, spent_time: spent_time)
    end
    super
  end
end
