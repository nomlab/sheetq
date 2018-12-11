module Sheetq
  class Config < Clian::Config::Toplevel

    class General < Clian::Config::Element
      define_syntax :client_id => String,
                    :client_secret => String,
                    :cache_directory => String,
                    :default_user => String,
                    :default_sheet_id  => String
    end # class General

    define_syntax :general => General

  end # Config
end # Sheetq
