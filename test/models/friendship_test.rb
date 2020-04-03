require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  test "should not persist if member and friend is same" do
    member = members(:one)
    friendship = Friendship.new(member_id: member.id, friend_id: member.id )

    assert_not friendship.save
    assert_includes friendship.errors.full_messages, "Member cannot friend self!"
  end

  test "should not persist duplicates" do
    member = members(:one)
    member2 = members(:two)
    friendship = Friendship.create(member_id: member.id, friend_id: member2.id )
    friendship = Friendship.create(member_id: member.id, friend_id: member2.id )

    assert_not friendship.persisted?
    assert_includes friendship.errors.full_messages, "Member has already been taken"
  end

  test "should not persist twice" do
    member = members(:one)
    member2 = members(:two)
    friendship = Friendship.create(member_id: member.id, friend_id: member2.id )
    friendship2 = Friendship.create(member_id: member2.id, friend_id: member.id )

    assert_not friendship2.persisted?
    assert_includes friendship2.errors.full_messages, "friendship exists"
  end

  test "should persist" do
    member = members(:one)
    member2 = members(:two)
    friendship = Friendship.create(member_id: member.id, friend_id: member2.id )

    assert friendship.persisted?
  end
end
