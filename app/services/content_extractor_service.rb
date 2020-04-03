class ContentExtractorService
  def self.call(object)
    return if !object.saved_changes[:website_url]

    object.url_extracts.delete_all

    content  = HTTParty.get(object.website_url).body
    doc      = Nokogiri::HTML::Document.parse(content)
    headings = doc.css('h1, h2, h3').map(&:text)

    headings.each do |content|
      object.url_extracts.create(content: content.squish)
    end

  rescue Errno::ECONNREFUSED, HTTParty::Error, SocketError => e
    Rails.logger.error e
  end
end