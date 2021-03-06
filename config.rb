require "lib/path_helpers"
require "lib/image_helpers"
require "lib/multimage_helpers"

page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

set :url_root, ENV.fetch('BASE_URL')

ignore '/templates/*'

LOCALES = ENV['LANGS'].split(",").map(&:to_sym)
activate :i18n, langs: LOCALES, mount_at_root: LOCALES[0]

activate :asset_hash
activate :directory_indexes
#activate :pagination
activate :inline_svg

activate :dato, token: ENV.fetch('DATO_API_TOKEN'), live_reload: true

webpack_command =
  if build?
    "yarn run build"
  else
    "yarn run dev"
  end

activate :external_pipeline,
  name: :webpack,
  command: webpack_command,
  source: ".tmp/dist",
  latency: 1

configure :build do
  activate :minify_html do |html|
    html.remove_input_attributes = false
  end
  activate :search_engine_sitemap,
    default_priority: 0.5,
    default_change_frequency: 'weekly'
end

configure :development do
  activate :livereload
end

helpers do
  include PathHelpers
  include ImageHelpers
  include MultimageHelpers

end

dato.tap do |dato|
  dato.pages.each do |article|
    proxy "info/#{article.slug}/index.html",
      "templates/page.html",
      locals: { page: article }
  end
  dato.books.each do |book|
    proxy "libri/#{book.slug}/index.html",
      "templates/libro.html",
      locals: { book: book }
  end
  dato.collections.each do |col|
    proxy "collane/#{col.slug}/index.html",
      "templates/collana.html",
      locals: { col: col }
  end
  dato.authors.each do |author|
    proxy "autori/#{author.slug}/index.html",
      "templates/autore.html",
      locals: { author: author }
  end
  dato.blog_post_olds.each do |post|
    proxy "blog/posts/#{post.slug}/index.html",
      "templates/old_post.html",
      locals: { post: post }
  end
end

# dato.tap do |dato|
#   paginate(
#     dato.articles.sort_by(&:published_at).reverse,
#     '/articles',
#     '/templates/articles.html'
#   )
# end

proxy "site.webmanifest",
  "templates/site.webmanifest",
  :layout => false

proxy "browserconfig.xml",
  "templates/browserconfig.xml",
  :layout => false

proxy "/_redirects",
  "/templates/redirects.txt",
  :layout => false
