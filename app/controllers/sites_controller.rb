class SitesController < ApplicationController
  
  before_filter :authenticate, :except => [ :up, :down ]
  before_filter :assign_site_by_secret_key, :only => [ :up, :down ]
  before_filter :valid_subscription?, :only => [ :create ]
  before_filter :assign_site, :only => [ :show, :update, :refresh, :destroy ]
  
  def index
    @sites = Site.all(:conditions => { :user_id => current_user.id })
  end
  
  def create
    @site = Site.new(params[:site])
    if ! @site.save
      flash[:error] = @site.errors.full_messages.join('<br/>')
    end
    redirect_to sites_path
  end

  def show
  end
  
  def update
    if ! @site.update_attributes(params[:site])
      flash[:error] = @site.errors.full_messages.join('<br/>')
    end
    redirect_to sites_path
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
