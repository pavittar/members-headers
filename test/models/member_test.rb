require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  test "should not persist without name and website_url" do
    member = Member.new

    assert_not member.save
    assert_includes member.errors.full_messages, "Name can't be blank"
    assert_includes member.errors.full_messages, "Website URL can't be blank"
  end

  test "should persist" do
    member = Member.new(name: "Name", website_url: 'http://example.com')
    assert member.save
  end

  test "should have uniq name" do
    count = Member.count
    member = Member.create(name: "Name", website_url: 'http://example.com')
    member2 = Member.create(name: "Name", website_url: 'http://example.com')
    assert_equal (count + 1), Member.count

    assert_includes member2.errors.full_messages, "Name has already been taken"
  end

  test "should have short website url" do
    member = Member.create(name: "Name", website_url: 'http://example.com')
    assert_not_nil member.website_url_short
  end

  test "should return correct count" do
    members = Member.with_friends_count
    member1 = members.detect { |m| m == members(:one) }
    member3 = members.detect { |m| m == members(:three) }
    member4 = members.detect { |m| m == members(:four) }
    member5 = members.detect { |m| m == members(:five) }

    assert_equal 2, member1.friends_count
    assert_equal 2, member3.friends_count
    assert_equal 1, member4.friends_count
    assert_equal 0, member5.friends_count
  end

  test "should have url_extracts" do
    member = members(:one)
    assert member.respond_to?(:url_extracts)
  end
end
