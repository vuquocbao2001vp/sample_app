class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  scope :newest, ->{order created_at: :desc}
  scope :by_user, ->(user_id){where user_id:}
  scope :by_user_status, lambda {|user_id|
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id:)
  }

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.max_length_content_140}
  validates :image, content_type: {in: Array.new(Settings.validate_image_format),
                                   message: I18n.t("validate.valid_image_format")},
                    size: {less_than: Settings.max_image_size_5_MB.megabytes,
                           message: I18n.t("validate.less_than_5MB_image_size")}

  def display_image
    image.variant(resize_to_limit: Array.new(Settings.limit_image_area))
  end
end
