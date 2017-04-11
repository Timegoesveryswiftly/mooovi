class Scraping
  def self.movie_urls
    links = []
    agent = Mechanize.new
    next_url = ""

    while true do
      current_page = agent.get("http://review-movie.herokuapp.com/" + next_url)
      elements = current_page.search('.entry-title a') # search : cssかxpathで検索し、NodeSetを返す
        elements.each do |ele|
          links << ele.get_attribute('href') # href属性の取得
        end
      next_link = current_page.at('.pagination .next a')
      break unless next_link #next_linkが偽なら
      next_url = next_link.get_attribute('href')
    end
    links.each do |link|
      get_product('http://review-movie.herokuapp.com' + link)
    end
  end

  def self.get_product(link)
    agent = Mechanize.new
    page = agent.get(link)
    title = page.at('.entry-title').inner_text if page.at('.entry-title') # タグ内のテキスト文を返す

    image_url = page.at('.entry-content img')[:src] if page.at('.entry-content img') # 画像があれば
    director = page.at('.director span').inner_text if page.at('.director span') # 画像があれば
    detail = page.at('.entry-content p').inner_text if page.at('.entry-content p') # 画像があれば
    open_date = page.at('.date span').inner_text if page.at('.date span') # 画像があれば

    product = Product.where(title: title).first_or_initialize
    product.image_url = image_url
    product.director = director
    product.detail = detail
    product.open_date = open_date
    product.save
  end
end
