class PartsController < ApplicationController
  def index
    @parts = Part.all
  end

  def show
    @part = Part.find(params[:id])
  end

  def new
    @part = Part.new
  end

  def create
    @part = Part.new(resource_params)

    if @part.save
      redirect_to @part
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @part = Part.find(params[:id])
  end

  def update
    @part = Part.find(params[:id])
    respond_to do |format|
      if @part.update(resource_params)
        # @user.avatar.attach(params[:avatar])
        format.html { redirect_to @part, notice: 'Part was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @part.destroy

    respond_to do |format|
      format.html { redirect_to parts_url }
      format.json { head :no_content }
    end
  end

  private
  def resource_params
    params.require(:part).permit(:title, :brand, :describe, :detail_num, :o_e)
  end
end
