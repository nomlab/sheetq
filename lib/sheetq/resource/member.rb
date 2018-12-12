module Sheetq
  module Resource
    class Member
      attr_reader :id, :name, :title, :account, :team, :mail, :phone,
                  :google, :twitter, :github, :organization

      def initialize(id, name, title, account, team, mail, phone, google,
                     twitter, github, organization)

        @id, @name, @title, @account, @team, @mail, @phone, @google,
        @twitter, @github, @organization = id, name, title, account, team,
        mail, phone, google, twitter, github, organization
      end

      def active?
        /\d{4}[MBD]/ !~ self.title
      end

      def match(keyword)
        regexp = Regexp.new(Regexp.quote(keyword), Regexp::IGNORECASE)

        self.to_s.split("\n").each do |s|
          return true if regexp =~ s.sub(/^[^:]+:\s*/, "")
        end
        return false
      end

      def to_s
        "ID: #{@id}\n" +
          "Name: #{@name}\n" +
          "Title: #{@title}\n" +
          "Account: #{@account}\n" +
          "Team: #{@team}\n" +
          "Mail: #{@mail}\n" +
          "Phone: #{@phone}\n" +
          "Google: #{@google}\n" +
          "Twitter: #{@twitter}\n" +
          "GitHub: #{@github}\n" +
          "Organization: #{@organization}"
      end
    end # class Member
  end # module Resource
end # module Sheetq
