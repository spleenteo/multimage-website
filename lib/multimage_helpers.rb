module MultimageHelpers
  module_function

  def book_price(book)
    if book.discount.present? and book.discount > 0
      p = (book.price * book.discount) / 100;
    else
      p = book.price
    end
    number_to_currency(p, :unit => "€", :locale=>"it")
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

  def link_to_authors(authors)
    authors.map do |author|
      link_to author_name(author), "/autori/#{author.slug}"
    end.to_sentence
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

end
