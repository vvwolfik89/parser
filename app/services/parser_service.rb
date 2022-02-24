class ParserService
  require 'open-uri'
  require 'nokogiri'
  require 'json'

  attr_reader :part

  def initialize(part)
    @part = part
  end

  def show_data
    # manager = ProxyFetcher::Manager.new
    # manager.raw_proxies

    # proxy = manager.raw_proxies.sample
    data = build_data(part) #, proxy)
    save_data_rating(data, part) if data.present?
      # [part.id, saved_value]
  end

  protected

  def build_data(part) #, proxy)

    # proxy = "42.200.57.252:3128"

    o_e = part.o_e
    url = "https://tehnomir.com.ua/index.php?r=product%2Fsearch&SearchForm%5Bcode%5D=#{o_e}&SearchForm%5BbrandId%5D=&SearchForm%5BprofitLevel%5D=&SearchForm%5BdaysFrom%5D=&SearchForm%5BdaysTo%5D=&sort=priceOuterPrice&SearchForm%5BcatalogRequest%5D="

    html = URI.open(url) #, :proxy => "http:#{proxy}")

    doc = Nokogiri::HTML(html)

    if doc.css('.dataTable').present?
      brandid = check_brand_info(doc, part.brand) || ''
      url = "https://tehnomir.com.ua/index.php?r=product%2Fsearch&SearchForm%5Bcode%5D=#{o_e}&SearchForm%5BbrandId%5D=#{brandid}&SearchForm%5BprofitLevel%5D=&SearchForm%5BdaysFrom%5D=&SearchForm%5BdaysTo%5D=&sort=priceOuterPrice&SearchForm%5BcatalogRequest%5D="
      html = URI.open(url)
      doc = Nokogiri::HTML(html)
    end

    scripts = doc.search('script').to_a
    script = scripts.bsearch{|script| script.content.include? "var options"}
    if script
      script_str = script.content.strip.split("\n").to_a
        sc_v = script_str.select { |e| e.include? "var options"}.first
        data_value_str = JSON.parse(sc_v.gsub(/([{,]\s*):([^>\s]+)\s*=>/, '\1"\2"=>').gsub(/var options = /, '').gsub(/;/, ''))
        data_value = data_value_str["data"].reject! {|hash| !hash.has_key?("code")} if data_value_str.present? && data_value_str["data"] != 0

        currency = doc.at_css('.currency-block').text
        currency_data = JSON.parse(currency.gsub(/ |\n/, '').gsub(/=/, ':"').gsub(/,/, '.').gsub(/;/, '",').gsub(/1USD/, {'1USD' => '{"USD"'}).gsub(/1EUR/, '"EUR"').gsub(/USD$/, 'USD"}'))
        OpenStruct.new(
          part_id: part.id,
          value_data: data_value,
          currency_data: currency_data
        )
    end
  end

  def save_data_rating(data, part)
    DataRating.create!(
      data: data.value_data || {"message" => "Does not have value"},
      currency: data.currency_data,
      part_id: part.id
    )
  end

  def check_brand_info(doc, brand)
    brandid = ''
    doc.css('.dataTable').css('tbody').css('tr').each do |e|
      if e.css('td')[0].text.gsub(' ', '').upcase.include? ("#{brand[0..2].upcase}")
        brandid = e.css('td')[3].css('a')[0]["data-brandid"]
      end
    end
    brandid
  end
end
