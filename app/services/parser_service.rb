class ParserService
  require 'open-uri'
  require 'nokogiri'
  require 'json'

  include ActiveModel::Model

  attr_accessor :parts

  validates :parts, presence: true

  def show_data
    parts.map do |part|
      sleep 3
      data = build_data(part)
      saved_value = save_data_rating(data, part) if data.present?
      [part.id, saved_value]
    end
  end

  protected

  def build_data(part)
    proxy = "http://50.114.128.23:3128"
    o_e = part.o_e
    url = "https://tehnomir.com.ua/index.php?r=product%2Fsearch&SearchForm%5Bcode%5D=#{o_e}&SearchForm%5BbrandId%5D=&SearchForm%5BprofitLevel%5D=&SearchForm%5BdaysFrom%5D=&SearchForm%5BdaysTo%5D=&sort=priceOuterPrice&SearchForm%5BcatalogRequest%5D="
    html = URI.open(url)#, :proxy => proxy)
    doc = Nokogiri::HTML(html)

    if doc.css('.dataTable').present?
      brand_info = check_brand_info(doc, part.brand) || ''
      url = "https://tehnomir.com.ua/index.php?r=product%2Fsearch&SearchForm%5Bcode%5D=#{o_e}&SearchForm%5BbrandId%5D=#{brand_info}&SearchForm%5BprofitLevel%5D=&SearchForm%5BdaysFrom%5D=&SearchForm%5BdaysTo%5D=&sort=priceOuterPrice&SearchForm%5BcatalogRequest%5D="
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
    DataRating.create(
      data: data.value_data || {"message" => "Does not have value"},
      currency: data.currency_data,
      part_id: part.id
    ).valid?
  end

  def check_brand_info(doc, brand)
    doc.css('.dataTable').css('tbody').css('tr').select do |e|
        e.css('td')[3].css('a')[0]["data-brandid"] if e.css('td')[0].text.gsub(' ', '').include? ("#{brand[1..3]}")
    end.first
  end
end
