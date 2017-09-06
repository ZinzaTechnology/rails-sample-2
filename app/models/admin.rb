class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :actor_notifications, class_name: "NewNotification", as: :actor, dependent: :destroy
  has_many :posts, as: :user, dependent: :destroy

  WEB_HOOK_URL_MAIL = "sample hook url".freeze

  def as_public_json
    as_json(except: %i[password])
  end

  def self.notify_slack(responses_mailer)
    return unless Rails.env.production?

    notifier = Slack::Notifier.new WEB_HOOK_URL_MAIL
    content = responses_mailer.text_part.body.decoded
    message = "subject: #{responses_mailer.subject}\n\nto: #{responses_mailer.to.to_a.join(',')}\ncc: #{responses_mailer.cc.to_a.join(',')}\nbcc: #{responses_mailer.bcc.to_a.join(',')}\n\n#{content}"
    notifier.ping message
  end
end
