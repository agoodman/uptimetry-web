class Domains::EndpointsController < ApplicationController

  before_filter :assign_domain
  
  def index
    @endpoints = Endpoint.where(domain_id: @domain.id)
  end
  
  def assign_domain
    @domain = Domain.find(params[:domain_id])
    deny_access unless @domain.user_id==current_user.id
  end
  
end
