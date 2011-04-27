class SitesController < ApplicationController
  
  before_filter :authenticate, :except => [ :up, :down ]
  
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
    @site = Site.find_by_secret_key(params[:secret_key])
    @site.update_attributes(:up => true, :last_successful_attempt => Time.now)
    head :ok
  end
  
  def down
    @site = Site.find_by_secret_key(params[:secret_key])
    # send email only if site was up at last attempt
    SiteMailer.notify(@site).deliver if @site.up
    @site.update_attributes(:up => false)
    head :ok
  end
  
end
