require 'test_helper'

class ContentExtractorServiceTest < ActiveSupport::TestCase
  test "should download content" do
    member = members(:one)
    member.update(website_url: 'http://github.com')

    assert member.url_extracts.length == 0

    ContentExtractorService.call(member)

    assert member.url_extracts.length > 0
  end

  test "should not download content if same website url" do
    member = members(:one)

    assert member.url_extracts.length == 0
    ContentExtractorService.call(member)
    assert member.url_extracts.length == 0
  end

  test "should not download content if invalid website url" do
    member = members(:one)
    member.update(website_url: 'http://ebd0b19c2e9d327f7aa599259d9d6482.com')

    assert member.url_extracts.length == 0
    ContentExtractorService.call(member)
    assert member.url_extracts.length == 0
  end
end