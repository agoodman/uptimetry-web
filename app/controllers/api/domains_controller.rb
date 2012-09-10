class Api::DomainsController < Api::BaseController

  before_filter :authorize
  before_filter :can_access_domain?, :only => [ :show, :update, :destroy ]
  before_filter :valid_subscription?, :only => [ :create ]

  def index
    @domains = current_user.domains
    respond_to do |format|
      format.json { render :json => @domains.to_json(:only => [:id,:name])}
    end
  end
  
  def create
    @domain = Domain.new(params[:domain])
    @domain.user_id = current_user.id
    respond_to do |format|
      if @domain.save
        format.json { render :json => @domain.to_json(:only => [:id,:name]), :status => :ok }
      else
        format.json { render :json => { :errors => @domain.errors.full_messages }, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @domain = Domain.find(params[:id])
    respond_to do |format|
      format.json { render :json => @domain, :status => :success }
    end
  end
  
  def update
    @domain = Domain.find(params[:id])
    respond_to do |format|
      if @domain.update_attributes(params[:domain])
        format.json { head :ok }
      else
        format.json { render :json => { :errors => @domain.errors.full_messages }, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @domain = Domain.find(params[:id])
    @domain.destroy
    head :ok
  end
  
  private
  
  def can_access_domain?
    deny_access unless current_user.domain_ids.include?(params[:id].to_i)
  end
  
end
