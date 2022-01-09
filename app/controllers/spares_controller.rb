class SparesController < ApplicationController
  def index
    @data = ParserService.new.show_data
  end
end
