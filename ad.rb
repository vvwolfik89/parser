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
num = 'GJ6A43980C'
url = "https://tehnomir.com.ua/index.php?r=product%2Fsearch&SearchForm%5Bcode%5D=#{num}&SearchForm%5BbrandId%5D=&SearchForm%5BprofitLevel%5D=10&SearchForm%5BdaysFrom%5D=&SearchForm%5BdaysTo%5D=&sort=priceOuterPrice&SearchForm%5BcatalogRequest%5D="
      # "https://tehnomir.com.ua/index.php?r=product%2Fsearch&SearchForm%5Bcode%5D=#{num}&SearchForm%5BbrandId%5D=&SearchForm%5BprofitLevel%5D=10&SearchForm%5BdaysFrom%5D=&SearchForm%5BdaysTo%5D=&sort=priceOuterPrice&SearchForm%5BcatalogRequest%5D="
html = URI.open(url)
doc = Nokogiri::HTML(html)


js = doc.search('script')[31].text.strip.split("\n")
curency = doc.at_css('.currency-block').text
data = JSON.parse(js[34].gsub(/([{,]\s*):([^>\s]+)\s*=>/, '\1"\2"=>').gsub(/var options = /, '').gsub(/;/, ''))
p data["data"].count
s = data["data"].reject!{|hash| !hash.has_key?("code")}
curency_json = JSON.parse(curency.gsub(/ |\n/, '').gsub(/=/, ':"').gsub(/,/, '.').gsub(/;/, '",').gsub(/1USD/, {'1USD' => '{"USD"'}).gsub(/1EUR/, '"EUR"').gsub(/USD$/, 'USD"}'))
p curency_json['EUR'].class



