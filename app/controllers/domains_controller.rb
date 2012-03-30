class DomainsController < ApplicationController

  before_filter :authorize
  before_filter :assign_collection, only: :index
  before_filter :assign_object, only: :show
  
  def index
  end
  
  def show
  end
  
  def assign_collection
    @domains = Domain.includes(:endpoints).where(user_id: current_user.id)
  end
  
  def assign_object
    @domain = Domain.includes(:endpoints).find(params[:id])
  end

end
