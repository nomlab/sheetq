module Sheetq
  module Resource
    dir = File.dirname(__FILE__) + "/resource"

    autoload :Member,             "#{dir}/member.rb"
    autoload :NomnichiArticle,    "#{dir}/nomnichi_article.rb"

  end # module Resource
end # module Sheetq
