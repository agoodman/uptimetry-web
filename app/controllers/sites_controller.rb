class SitesController < ApplicationController
  
  before_filter :authorize, :except => [ :up, :down ]
  before_filter :assign_site_by_secret_key, :only => [ :up, :down ]
  before_filter :valid_subscription?, :only => [ :create ]
  before_filter :assign_site, :only => [ :show, :edit, :update, :refresh, :remove, :destroy ]
  
  respond_to :html, :js
  
  def index
    @sites = Site.all(:conditions => { :user_id => current_user.id })
    respond_with(@sites, status: :ok)
  end
  
  def create
    @site = Site.new(params[:site])
    @site.user_id = current_user.id
    
    if @site.save
      redirect_to site_path(@site)
    else
      redirect_to new_site_path(site: params[:site]), alert: @site.errors.full_messages
    end
  end

  def new
    @site = Site.new(params[:site])
    respond_with(@site, status: :ok)
  end
  
  def show
    respond_with(@site, status: :ok)
  end
  
  def edit
    respond_with(@site, status: :ok)
  end
  
  def update
    if @site.update_attributes(params[:site])
      redirect_to site_path(@site)
    else
      redirect_to site_path(@site), alert: @site.errors.full_messages
    end
  end
  
  def refresh
    monitoring_worker = MonitoringWorker.new
    monitoring_worker.url = @site.url
    if monitoring_worker.monitor(@site.url)
      site_is_up
    else
      site_is_down
    end
    respond_to do |format|
      format.html { render :action => :show }
      format.js { render :layout => false }
    end
  end
  
  def remove
    respond_with(@site)
  end
  
  def destroy
    @site.destroy
    
    redirect_to sites_path
  end
  
  # callbacks for SimpleWorker
  def up
    site_is_up
    head :ok
  end
  
  def down
    site_is_down
    head :ok
  end
  
  private
  
  def assign_site
    @site = Site.find(params[:id])
  end
  
  def assign_site_by_secret_key
    @site = Site.find_by_secret_key(params[:secret_key])
  end
  
  def site_is_up
    @site.up = true
    @site.last_successful_attempt = Time.now
    @site.down_count = 0
    @site.save
  end
  
  def site_is_down
    if @site.down_count == 1
      # send email only on second consecutive failure
      SiteMailer.notify(@site).deliver 
    end
    @site.up = false
    @site.down_count = @site.down_count + 1
    @site.save
  end
  
end
