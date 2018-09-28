class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates_presence_of :text

  after_create :send_comment_notification

  private
    def send_comment_notification
      Mailer.send_comment_notification(self).deliver_now
    end
end
