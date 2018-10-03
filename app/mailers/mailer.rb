class Mailer < ActionMailer::Base
  default from: 'weeklydo@ct2c.fr'
  layout 'mailer'
  add_template_helper(TimeHelper)

  def send_invitation(current_user, email, project, raw_token = nil)
    @user = current_user
    @project = project
    @new_user = User.find_by_email(email)
    @token = raw_token

    mail to: email, subject: "WeeklyDo - #{t('mailers.subjects.send_invitation', inviter_name: current_user.fullname, project_name: @project.name)}"
  end

  def send_timesheets(email)
    I18n.locale = :fr

    @first_of_previous_month = (Time.now - 1.month).beginning_of_month.beginning_of_day
    @last_of_previous_month = (Time.now.beginning_of_month - 1.day).end_of_day

    @month = I18n.t("date.month_names")[@first_of_previous_month.month]

    mail :to => email, subject: "WeeklyDo - #{t('words.invoices_to_do', month: @month)}"
  end

  def send_comment_notification(comment)
    @comment = comment
    @writer = @comment.user
    @task = @comment.task
    users = @comment.task.users - [@comment.user]

    if users.any?
      emails = users.map(&:email)

      mail to: emails, subject: "WeeklyDo - #{@comment.task.project.name} > #{@writer.fullname} a commenté la tâche #{@task.name}"
    end
  end

end
