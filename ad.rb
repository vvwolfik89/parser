require 'open-uri'
require 'nokogiri'
url = 'http://google.com'
html = open(url)
doc = Nokogiri::HTML(html)
p doc.inspect
