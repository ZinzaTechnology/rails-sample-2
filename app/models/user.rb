class User < ApplicationRecord
  acts_as_paranoid

  geocoded_by :full_street_address, latitude: :address_lat, longitude: :address_long
  after_validation :geocode

  has_many :comments, as: :user, dependent: :destroy
  has_many :notifications, class_name: "NewNotification", as: :recipient, dependent: :destroy

  enum status: %i[active inactive]

  validates :website_url, format: URI.regexp(%w[http https]), allow_blank: true

  scope :not_by_uid, ->(uid) { where.not(uid: uid) }
  scope :register_in_ranger, ->(start_time, end_time) { where(created_at: start_time..end_time) }
  scope :by_ids, ->(ids) { where(id: ids) }
  scope :using_service, -> { where(leave_service: false) }
  scope :leaved_service, -> { where(leave_service: true) }

  def firebase_image(image_type)
    return if Rails.env.test?

    Firestore.new.list_uploaded_file_access_keys(image_type, uid)
  end

  def as_public_json
    month = Time.zone.now.strftime("%Y/%m")
    works = self.works.includes(:request).in_month(month)

    as_json(include: %i[director desired_worktimes badges]).merge(
      like_count: like_count,
      review_count: review_count
    )
  end
end
