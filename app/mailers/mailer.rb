class Mailer < ActionMailer::Base
  default from: 'contact@ct2c.fr'
  layout 'mailer'
  add_template_helper(TimeHelper)

  def send_timesheets(email)
    I18n.locale = :fr

    @first_of_previous_month = (Time.now - 1.month).beginning_of_month
    @last_of_previous_month = Time.now.beginning_of_month - 1.day

    @month = I18n.t("date.month_names")[@first_of_previous_month.month]

    mail :to => email, subject: "#{@month} #{@first_of_previous_month.year} - Les factures à faire"
  end

end
