class ProxyServersController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  def index
    # @proxy_servers = Part.page(params[:page])
  end

  def show
    @proxy_server = ProxyServer.find(params[:id])
    respond_to do |format|
      format.html { render :show }
    end
  end

  def new
  end

  def create
    @proxy_server = ProxyServer.new(resource_params)

    if @proxy_server.save
      redirect_to @proxy_server
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @proxy_server = ProxyServer.find(params[:id])
  end

  def update
    @proxy_server = ProxyServer.find(params[:id])
    respond_to do |format|
      if @proxy_server.update(resource_params)
        # @user.avatar.attach(params[:avatar])
        format.html { redirect_to @proxy_server, notice: 'Part was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @proxy_server.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @proxy_server.destroy

    respond_to do |format|
      format.html { redirect_to proxy_servers_url }
      format.json { head :no_content }
    end
  end

  private
  def resource_params
    params.require(:proxy_server).permit(:server, :port )
  end
end
