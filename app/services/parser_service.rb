class ParserService
  URL = 'https://emex.ru/products/GBH000100/G.U.D/6171'
  URL1 = 'https://emex.ru/products/GBH000100'
  # URL = 'https://emex.ru/api/search/search2?detailNum=GA5R3438X&isHeaderSearch=true&showAll=false&searchString=GA5R3438X&locationId=6171&longitude=39.5105&latitude=52.5704'
  # URL1 = 'https://emex.ru/search?q=GA5R3438X'
  # URL2 = 'https://mc.yandex.ru/clmap/56757502?page-url=https%3A%2F%2Femex.ru%2F&pointer-click=rn%3A340305639%3Ax%3A25848%3Ay%3A29490%3At%3A107%3Ap%3AA%3FAAAAAAAA1AAAAAA%3AX%3A1066%3AY%3A67&browser-info=gdpr%3A14%3Au%3A1640196612638407248%3Av%3A722%3Avf%3Aykcyjkqfpgygy7cm9r%3Arqnl%3A1%3Ast%3A1640727285&t=gdpr(14)ti(0)&force-urlencoded=1'

  def show_data
    # url = 'https://emex.ru/products/GA5R3438X/Mazda/6171'
    data = URI.open(URL)
# html = open(url)
    doc = Nokogiri::HTML(data)
    data1 = URI.open(URL1)
    doc2 = Nokogiri::HTML(data1)

    v1 = doc.css("#__NEXT_DATA__").text
    v2 = doc2.css("#__NEXT_DATA__").text

    dat = JSON.parse(v1.gsub(/([{,]\s*):([^>\s]+)\s*=>/, '\1"\2"=>'))
    dat1 = JSON.parse(v2.gsub(/([{,]\s*):([^>\s]+)\s*=>/, '\1"\2"=>'))

    doc2
      # value = doc.css("#__NEXT_DATA__").text
    # doc
    # data = JSON.parse(value.gsub(/([{,]\s*):([^>\s]+)\s*=>/, '\1"\2"=>'))
    # data
    # data['props']
  end

  def notify
    if self.valid?
      body = render_template
      AgentNotification.create(
        title: title,
        body: body,
        agent: agent,
        view_type: view_type,
        sender: sender
      )
      $redis.publish(agent.full_extension, { messageType: 'alert', message: title }.to_json )
    end
  end

  protected

  def render_template
    view = ActionView::Base.new(Rails.configuration.paths['app/views'])
    view.class_eval do
      include Rails.application.routes.url_helpers
      include ApplicationHelper
      def protect_against_forgery?
        false
      end
    end
    view.render(
      template: "agent_notifications/templates/#{self.template}",
      formats: [:html, :text],
      handlers: [:erb],
      locals: self.template_options || {}
    )
  end
end
