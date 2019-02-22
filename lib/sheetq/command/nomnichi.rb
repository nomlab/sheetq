module Sheetq
  module Command
    class Nomnichi < Base
      def initialize(member_sheet_id, whosnext = false)
        spreadsheet = Sheetq::Service::Spreadsheet.new(client, member_sheet_id)
        server = spreadsheet.sheet("members", Sheetq::Resource::Member)
        members = server.fetch.select {|m| m.active? }
        current_member_account_names = members.map(&:account)
        articles = Sheetq::Service::Nomnichi.new.fetch

        @message = []

        if whosnext
          @message << whos_next(current_member_account_names, articles)
        else
          articles.each do |article|
            @message << "#{article.published_on.to_date} - #{article.user_name} - #{article.title}"
          end
        end
        puts @message.join("\n")
      end

      private

      def whos_next(current_member_account_names, articles)
        epoch = Time.new(1970, 1, 1)
        old_to_new_articles =  articles.sort {|a, b| a.published_on <=> b.published_on}
        latest_published_time = Hash.new

        current_member_account_names.each do |user_name|
          latest_published_time[user_name] = epoch
        end

        old_to_new_articles.each do |article|
          next unless current_member_account_names.include?(article.user_name)
          latest_published_time[article.user_name] = article.published_on
        end

        return latest_published_time.sort{|a, b| a[1] <=> b[1]}.first[0]
      end
    end # class Nomnichi
  end # module Command
end # module Sheetq
