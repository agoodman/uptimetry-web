class SitesController < ApplicationController
  
  before_filter :authenticate, :except => [ :up, :down ]
  before_filter :assign_site_by_secret_key, :only => [ :up, :down ]
  
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

  def update
    @site = Site.find(params[:id])
    if ! @site.update_attributes(params[:site])
      flash[:error] = @site.errors.full_messages.join('<br/>')
    end
    redirect_to sites_path
  end
  
  def destroy
    @site = Site.find(params[:id])
    @site.destroy
    
    redirect_to sites_path
  end
  
  # callbacks for SimpleWorker
  def up
    @site.update_attributes(:up => true, :last_successful_attempt => Time.now, :down_count => 0)
    head :ok
  end
  
  def down
    if @site.down_count == 1
      # send email only on second consecutive failure
      SiteMailer.notify(@site).deliver 
    end
    @site.update_attributes(:up => false, :down_count => @site.down_count+1)
    head :ok
  end
  
  private
  
  def assign_site_by_secret_key
    @site = Site.find_by_secret_key(params[:secret_key])
  end
  
end
