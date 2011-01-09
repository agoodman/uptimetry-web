class Api::SitesController < ApplicationController

  before_filter :authenticate
  before_filter :can_access_site?, :only => [ :show, :update, :destroy ]

  def index
    @sites = current_user.sites
  end
  
  def show
    @site = Site.find(params[:id])
    respond_to do |format|
      format.json { render :json => @site, :status => :success }
    end
  end
  
  def update
    @site = Site.find(params[:id])
    respond_to do |format|
      if @site.update_attributes(params[:site])
        format.json { head :ok }
      else
        format.json { render :json => { :errors => @site.errors.full_messages }, :status => :unprocessible_entity }
      end
    end
  end

  def destroy
    @site = Site.find(params[:id])
    @site.destroy
    head :ok
  end
  
  private
  
  def can_access_site?
    deny_access unless current_user.site_ids.include?(params[:id])
  end
  
end
