class DevicesController < ApplicationController

  before_filter :authorize

  respond_to :json
  
  def create
    @device = Device.new(params[:device])
    @device.save
    respond_with(@device)
  end
  
  def destroy
    @device = Device.find(params[:id])
    @device.destroy
    head :ok
  end
  
end
