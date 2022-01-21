# require "selenium-webdriver"
# require 'phantomjs'
# # require 'geckodriver-helper'
# url = "https://exist.ua"
# # driver = Selenium::WebDriver.for :chrome
# # driver = Selenium::WebDriver::Wait.new(timeout: 10)
#
# # driver.navigate.to "https://exist.ua/search/?query=GJ6A43980A"
#
# # element = driver.find_element(class: 'HeaderSearchstyle__HeaderSearchBlockInner-sc-eb4x8s-3 ePNNWp')
# # element.send_keys "Hello WebDriver!"
# # element.submit
#
# # puts driver.title
# #
# # driver.quit
# require 'selenium/webdriver/remote/http/curb'
#
# client = Selenium::WebDriver::Remote::Http::Curb.new
# driver = Selenium::WebDriver.for :firefox, http_client: client
#
#
# #
# # profile = Selenium::WebDriver::Firefox::Profile.new
# # profile.secure_ssl = true
# #
# # capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(accept_insecure_certs: true)
# # driver = Selenium::WebDriver.for :firefox, desired_capabilities: capabilities
#
# driver.navigate.to url
# driver.manage.timeouts.implicit_wait = 25
# p driver.title
# require 'curb'
# num = 'GJ6A43980C'
# url = "https://tehnomir.com.ua/index.php?r=product%2Fsearch&SearchForm%5Bcode%5D=#{num}&SearchForm%5BbrandId%5D=&SearchForm%5BprofitLevel%5D=&SearchForm%5BdaysFrom%5D=&SearchForm%5BdaysTo%5D=&sort=priceOuterPrice&SearchForm%5BcatalogRequest%5D="
#
# c = Curl::Easy.perform(url) do |curl|
#   curl.headers["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36"
#   curl.verbose = true
# end
# puts c.body_str
#
#
require 'open-uri'
require 'nokogiri'
require 'json'
# num = 'GJ6A43980C'
brand_id=''
num = '21013506060'
url = "https://tehnomir.com.ua/index.php?r=product%2Fsearch&SearchForm%5Bcode%5D=#{num}&SearchForm%5BbrandId%5D=#{brand_id}&SearchForm%5BprofitLevel%5D=&SearchForm%5BdaysFrom%5D=&SearchForm%5BdaysTo%5D=&sort=priceOuterPrice&SearchForm%5BcatalogRequest%5D="
html = URI.open(url)
doc = Nokogiri::HTML(html)
#
# script = doc.search('script')[31]
#
# a = if script && !script.text.empty? && doc.at_css('.product-cart-table').text
#   script = script.text.strip.split("\n")
#   data_value_str = JSON.parse(script[34].gsub(/([{,]\s*):([^>\s]+)\s*=>/, '\1"\2"=>').gsub(/var options = /, '').gsub(/;/, ''))
#   data_value = data_value_str["data"].reject! {|hash| !hash.has_key?("code")}
#
#   currency = doc.at_css('.currency-block').text
#   currency_data = JSON.parse(currency.gsub(/ |\n/, '').gsub(/=/, ':"').gsub(/,/, '.').gsub(/;/, '",').gsub(/1USD/, {'1USD' => '{"USD"'}).gsub(/1EUR/, '"EUR"').gsub(/USD$/, 'USD"}'))
#   OpenStruct.new(
#     part_id: 1,
#     value_data: data_value,
#     currency_data: currency_data
#   )
#     end
a = doc.at_css('.dataTable').css('tbody').css('tr').map do |b|
  {"#{b.css('td')[0].text}" =>  "#{b.css('td')[3].css('a')[0]["data-brandid"]}"}
end
p a



