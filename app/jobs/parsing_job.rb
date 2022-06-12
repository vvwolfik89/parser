class ParsingJob
  include Sidekiq::Job

  def perform(part_id)
    part = Part.find(part_id)
    parser_data = ParserService.new(part)
    parser_data.show_data
  end
end
