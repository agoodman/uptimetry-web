class OrdersController < ApplicationController
  
  before_filter :authorize
  
  respond_to :html
  
  def index
    @orders = Order.where(user_id: current_user.id)
  end
  
  def show
    @order = Order.includes(:nodes).where(user_id: current_user.id).find(params[:id])
  end
  
  def create
    @order = Order.new(params[:order])
    @order.user_id = current_user.id
    @order.save
    respond_with(@order)
  end
  
  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to orders_path
  end
  
end
