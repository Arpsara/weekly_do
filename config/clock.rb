# -*- encoding : utf-8 -*-

require 'clockwork'
require 'clockwork/database_events'
require 'daemons'
require_relative 'boot'
require_relative 'environment'

include TaskWorker

module Clockwork
  if ["development", "test"].include?(Rails.env)
    HOUR                     = 10.seconds
    DAY                      = 12.seconds
    MONTH                    = 15.seconds
  else
    HOUR                     = 1.hour
    DAY                      = 1.day
    MONTH                    = 1.month
  end

  # INVOICES - Send mail with timesheets
  # Uncomment to test
  # every(HOUR, 'send_mail_for_invoice') {
  every(HOUR, 'send_mail_for_invoice', at: '08:00', :if => lambda { |t| t.day == 1 }){
    User.where(receive_invoice: true).each do |user|
      Mailer.send_timesheets(user.email).deliver
    end
  }

  # TASKS - CHANGE PRIORITY DEPENDING ON DEADLINE DATE
  every(DAY, 'change_task_priorities') {
    change_task_priorities
  }
end
