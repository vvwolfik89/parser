class SparesController < ApplicationController
  def index
    ParsingJob.perform_async
  end
end
