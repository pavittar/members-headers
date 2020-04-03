class Friendship < ApplicationRecord
  belongs_to :member
  belongs_to :friend, class_name: "Member"

  validate :cannot_friend_self, :already_friended
  validates_uniqueness_of :member_id, scope: :friend_id

private
  def cannot_friend_self
    errors.add :member_id, "cannot friend self!" if member_id == friend_id
  end

  def already_friended
    errors.add :base, "friendship exists" if self.class.exists?(member_id: friend_id, friend_id: member_id)
  end
end