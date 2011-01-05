class SitesController < ApplicationController
  
  before_filter :authenticate
  
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
  
end
