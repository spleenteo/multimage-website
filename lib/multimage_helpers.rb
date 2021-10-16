module MultimageHelpers
  module_function

  def book_edition(book)
    e = book.edition
    "#{e}<sup>a</sup>"
  end

  def book_price(book)
=begin
TODO: logica da progettare quando ci sarà l'ecommerce
    if book.discount.present? and book.discount > 0
      p = (book.price * book.discount) / 100;
    else
      p = book.price
    end
=end
    p = book.price
    number_to_currency(p, :unit => "€", :locale=>"it")
  end

  def shoppable_book?(book)
    return book && !book.archive && book.price.present? && book.price > 0 && book.format == "Cartaceo"
  end


  def show_book_detail(label, detail)
    if detail.present? && label.present?
      content_tag :li do
        concat(
          content_tag(:strong, label) +": "+
          content_tag(:span, detail)
          )
        end
      end
    end

    def link_to_authors(book)
      prefix = book.edited_by.present? ? t("book.edited_by") : t("book.by")

      authors = book.authors.map do |author|
        link_to author_name(author), "/autori/#{author.slug}"
      end.to_sentence(two_words_connector: ' e ', last_word_connector: ' e ')

      illustrator = book.illustrator.present? ? content_tag(:div, t("book.illustrated_by") + " " + book.illustrator) : ""

      concat(
        content_tag(:div, prefix + " " + authors) + ("," if illustrator.present?) + " " + illustrator)
  end

  def show_book_license(book)
    if book.license.present?
      if book.license.code == "c"
        show_book_detail(t("book.copyright"), book.copyright)
      else
        license_url = "https://creativecommons.org/licenses/#{book.license.code}/4.0/deed.it"
        license_img_url = "https://i.creativecommons.org/l/#{book.license.code}/4.0/88x31.png"
        content_tag :li do
          concat(
            content_tag(:a, image_tag(license_img_url, style: "border-width: 0;", alt: "Creative Commons License"), rel: "license", target: "_blank", href: license_url) +
            tag(:br) +
            content_tag(:span, t("book.license_copy")) +" "+
            content_tag(:a, "Creative Commons #{book.license.name}", rel: "license", target: "_blank", href: license_url) +
            content_tag(:span, ".")
          )
        end
      end
    end
  end

  def author_name(author)
    author.alias.present? ? author.alias : author.full_name
  end

  def pluralize(word, count)
    if count != 1
      last_char = word[-1]
      substitute = last_char
      case last_char
        when "o"
          substitute = "i"
        when "e"
          substitute = "i"
        when "a"
          substitute = "e"
      end
      word = word.gsub(/.$/, substitute)
    end
    "#{count} #{word}"
  end

  def strip_html(content)
    re = /<("[^"]*"|'[^']*'|[^'">])*>/
    content.gsub(re, '')
  end


end
