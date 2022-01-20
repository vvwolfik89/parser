require 'faraday_middleware'

num = 'GJ6A43980C'
url = "https://tehnomir.com.ua/index.php?r=product%2Fsearch&SearchForm%5Bcode%5D=#{num}&SearchForm%5BbrandId%5D=&SearchForm%5BprofitLevel%5D=&SearchForm%5BdaysFrom%5D=&SearchForm%5BdaysTo%5D=&sort=priceOuterPrice&SearchForm%5BcatalogRequest%5D="
client =
  Faraday.new do |f|
    f.response :json
    f.adapter :net_http
  end
client.get(url)
