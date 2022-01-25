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

  # def show_data
  #   part = parts.find 70
  #     data = build_data(part)
  #     saved_value = save_data_rating(data, part) if data.present?
  #     [part.id, saved_value]
  # end
  #
  # def notify
  #   if self.valid?
  #     body = render_template
  #     AgentNotification.create(
  #       title: title,
  #       body: body,
  #       agent: agent,
  #       view_type: view_type,
  #       sender: sender
  #     )
  #     $redis.publish(agent.full_extension, {messageType: 'alert', message: title}.to_json)
  #   end
  # end

  protected

  def build_data(part)
    proxy = "http://50.114.128.23:3128"
    o_e = part.o_e
    brandid = BrandInfo.where(brand_name: part.brand).first.brandid if BrandInfo.where(brand_name: part.brand).present?
    url = "https://tehnomir.com.ua/index.php?r=product%2Fsearch&SearchForm%5Bcode%5D=#{o_e}&SearchForm%5BbrandId%5D=#{brandid}&SearchForm%5BprofitLevel%5D=&SearchForm%5BdaysFrom%5D=&SearchForm%5BdaysTo%5D=&sort=priceOuterPrice&SearchForm%5BcatalogRequest%5D="
    html = URI.open(url, :proxy => proxy)
    # , :proxy => 'http://(ip_address):(port)')
    doc = Nokogiri::HTML(html)

    if doc.css('.dataTable').present?
      check_brand_info(doc)
      brandid = BrandInfo.where(brand_name: part.brand).first.brandid if BrandInfo.where(brand_name: part.brand).present?
      url = "https://tehnomir.com.ua/index.php?r=product%2Fsearch&SearchForm%5Bcode%5D=#{o_e}&SearchForm%5BbrandId%5D=#{brandid}&SearchForm%5BprofitLevel%5D=&SearchForm%5BdaysFrom%5D=&SearchForm%5BdaysTo%5D=&sort=priceOuterPrice&SearchForm%5BcatalogRequest%5D="
      html = URI.open(url)
      doc = Nokogiri::HTML(html)
    end


    if doc.search('script')[31].present? && doc.search('script')[31].content.present?
      script = doc.search('script')[31]
    else
      script = doc.search('script')[32]
    end



    if script && !script.text.empty? && doc.at_css('.product-cart-table').present?
      script_str = script.text.strip.split("\n")
      sc_v = script_str.select {|e| e.include? "var options" }.first
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
    data_rating = DataRating.new(
      data: data.value_data,
      currency: data.currency_data,
      part_id: part.id
    )
    data_rating.save
  end

  def check_brand_info(doc)
    doc.css('.dataTable').css('tbody').css('tr').map do |b|
      BrandInfo.new(
        brand_name: "#{b.css('td')[0].text}",
        brandid: "#{b.css('td')[3].css('a')[0]["data-brandid"]}"
      ).save
    end
  end
end
