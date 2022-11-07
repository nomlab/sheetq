module Sheetq
  module Resource
    class Member
      attr_reader :id, :name, :joined, :title, :account, :team, :mail, :phone,
                  :google, :twitter, :github, :btmac, :organization

      def initialize(id, name, joined, title, account, team, mail, phone, google,
                     twitter, github, btmac, organization)

        @id, @name, @joined, @title, @account, @team, @mail, @phone, @google,
        @twitter, @github, @btmac, @organization = id, name, joined, title, account, team,
        mail, phone, google, twitter, github, btmac, organization
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
          "Joined: #{@joined}\n" +
          "Title: #{@title}\n" +
          "Account: #{@account}\n" +
          "Team: #{@team}\n" +
          "Mail: #{@mail}\n" +
          "Phone: #{@phone}\n" +
          "Google: #{@google}\n" +
          "Twitter: #{@twitter}\n" +
          "GitHub: #{@github}\n" +
          "BtMAC: #{@btmac}\n" +
          "Organization: #{@organization}"
      end
    end # class Member
  end # module Resource
end # module Sheetq
