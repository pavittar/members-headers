class Member < ApplicationRecord
  has_many :url_extracts
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :member

  scope :with_friends_count, -> {
    joins('
      LEFT JOIN friendships ON
        friendships.member_id = members.id
      OR
        friendships.friend_id = members.id
    ')
    .select("#{self.table_name}.*, COUNT(friendships.id) AS friends_count")
    .group('members.id')
  }

  validates :name, uniqueness: { case_sensative: false } , presence: :true
  validates :website_url, presence: :true

  before_save :shorten_url

private
  def shorten_url
    letters = Array('a'..'z')
    url = [Array.new(6) { letters.sample }.join, Array.new(2) { letters.sample }.join].join('.')

    self.website_url_short = "#{website_url.split(':').first}://#{url}"
  end
end