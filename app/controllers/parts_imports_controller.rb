class PartsImportsController < ApplicationController
  def new
    @parts_import = PartsImport.new
  end

  def create
    @parts_import = PartsImport.new(params[:parts_import])
    if @parts_import.save
      redirect_to parts_path
    else
      render :new
    end
  end
end
