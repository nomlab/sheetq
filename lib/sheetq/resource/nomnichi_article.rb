module Sheetq
  module Resource
    class NomnichiArticle
      attr_reader :id, :user_id, :title, :perma_link, :content,
      :published_on, :approved, :count, :promote_headline, :url

      def self.parse_hash(hash)
        self.new(
          hash["id"],
          hash["user_id"],
          hash["title"],
          hash["perma_link"],
          hash["content"],
          DateTime.parse(hash["published_on"]).to_time,
          hash["approved"],
          hash["count"],
          hash["promote_headline"],
          hash["url"])
      end

      def initialize(id, user_id, title, perma_link, content,
                     published_on, approved, count, promote_headline, url)

        @id, @user_id, @title, @perma_link, @content,
        @published_on, @approved, @count, @promote_headline,
        @url =id, user_id, title, perma_link, content,
        published_on, approved, count, promote_headline, url
      end

      # Since we have no way to aquire user_name from JSON,
      # get it from `perma_link`:
      #   "yoshida-s-20181116-132016" => yoshida-s
      #
      def user_name
        if /(.*)-\d{8}-\d{6}$/ =~ perma_link
          return $1
        else
          return "unknown"
        end
      end
    end # class NomnichiArticle
  end # module Resource
end # module Sheetq
