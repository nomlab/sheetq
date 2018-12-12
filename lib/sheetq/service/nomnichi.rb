module Sheetq
  module Service
    class Nomnichi
      def fetch(max_page = 10)
        require "json"
        require "net/http"
        base_url = "http://www.swlab.cs.okayama-u.ac.jp/lab/nom/articles.json?page="
        page, articles = 1, []

        loop do
          return articles if page > max_page
          res = Net::HTTP.get_response(URI.parse(base_url + page.to_s))
          return articles if res.code != "200" # no more articles
          articles += JSON.parse(res.body).map {|hash| Sheetq::Resource::NomnichiArticle.parse_hash(hash)}
          return articles if Time.now - articles.last.published_on > (365*24*60*60) # limit to 1-year
          page += 1
        end
      end
    end # Nomnichi
  end # Service
end # module Sheetq
