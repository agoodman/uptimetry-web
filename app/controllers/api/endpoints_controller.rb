class Api::EndpointsController < Api::BaseController

  before_filter :authorize
  before_filter :can_access_endpoint?, :only => [ :show, :update, :destroy ]
  before_filter :valid_subscription?, :only => [ :create ]

  def index
    @endpoints = Endpoint.joins(:domain).where(domains: { user_id: current_user.id }).order(:domain_id)
    respond_to do |format|
      format.json { render :json => @endpoints.to_json(:only => [:id,:domain_id,:url,:email,:last_successful_attempt,:up,:css_selector,:xpath,:down_count])}
    end
  end
  
  def create
    @endpoint = Endpoint.new(params[:endpoint])
    @endpoint.user_id = current_user.id
    respond_to do |format|
      if @endpoint.save
        format.json { render :json => @endpoint.to_json(:only => [:id,:domain_id,:url,:email,:css_selector,:xpath,:down_count]), :status => :ok }
      else
        format.json { render :json => { :errors => @endpoint.errors.full_messages }, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @endpoint = Endpoint.find(params[:id])
    respond_to do |format|
      format.json { render :json => @endpoint, :status => :success }
    end
  end
  
  def update
    @endpoint = Endpoint.find(params[:id])
    respond_to do |format|
      if @endpoint.update_attributes(params[:endpoint])
        format.json { head :ok }
      else
        format.json { render :json => { :errors => @endpoint.errors.full_messages }, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @endpoint = Endpoint.find(params[:id])
    @endpoint.destroy
    head :ok
  end
  
  private
  
  def can_access_endpoint?
    deny_access unless current_user.endpoint_ids.include?(params[:id].to_i)
  end
  
end
