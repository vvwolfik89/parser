class ParserService
  require 'open-uri'
  require 'nokogiri'
  require 'json'

  include ActiveModel::Model

  attr_accessor :parts

  validates :parts, presence: true

  def show_data
    parts.map do |part|
      data = build_data(part)
      save_data_rating(data, part) if data.present?
    end
  end
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
    o_e = part.o_e
    url = "https://tehnomir.com.ua/index.php?r=product%2Fsearch&SearchForm%5Bcode%5D=#{o_e}&SearchForm%5BbrandId%5D=&SearchForm%5BprofitLevel%5D=&SearchForm%5BdaysFrom%5D=&SearchForm%5BdaysTo%5D=&sort=priceOuterPrice&SearchForm%5BcatalogRequest%5D="
    html = URI.open(url)
    doc = Nokogiri::HTML(html)

    script = doc.search('script')[31]

    if script && !script.text.empty? && doc.at_css('.product-cart-table').present?
      script = script.text.strip.split("\n")
      data_value_str = JSON.parse(script[34].gsub(/([{,]\s*):([^>\s]+)\s*=>/, '\1"\2"=>').gsub(/var options = /, '').gsub(/;/, ''))
      data_value = data_value_str["data"].reject! {|hash| !hash.has_key?("code")}

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
    data_rating.save!
  end
end
