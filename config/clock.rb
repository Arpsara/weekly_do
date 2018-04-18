# -*- encoding : utf-8 -*-

require 'clockwork'
require 'clockwork/database_events'
require 'daemons'
require_relative 'boot'
require_relative 'environment'
require_relative "../app/models/mailer"

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
  # , at: '13:50', :if => lambda { |t| t.day == 1 }
  every(HOUR, 'send_mail_for_invoice', at: '08:00', :if => lambda { |t| t.day == 1 }){
    Mailer.send_timesheets("contact@ct2c.fr").deliver
  }
end
