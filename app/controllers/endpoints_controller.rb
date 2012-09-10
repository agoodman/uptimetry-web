class EndpointsController < ApplicationController
  
  before_filter :authorize, :except => [ :up, :down ]
  before_filter :assign_endpoint_by_secret_key, :only => [ :up, :down ]
  before_filter :valid_subscription?, :only => [ :create ]
  before_filter :assign_endpoint, :only => [ :show, :edit, :update, :refresh, :remove, :destroy ]
  
  respond_to :html, :js
  
  def index
    @endpoints = Endpoint.includes(:domain).where('domains.user_id = ?',current_user.id).order('domains.name asc, endpoints.url asc')
    respond_with(@endpoints, status: :ok)
  end
  
  def create
    @endpoint = Endpoint.new(params[:endpoint])
    @endpoint.domain = Domain.for_url(@endpoint.url, current_user.id)
    
    if @endpoint.save
      redirect_to domain_path(@endpoint.domain)
    else
      redirect_to new_endpoint_path(endpoint: params[:endpoint]), alert: @endpoint.errors.full_messages
    end
  end

  def new
    @endpoint = Endpoint.new(params[:endpoint])
    respond_with(@endpoint, status: :ok)
  end
  
  def show
    respond_with(@endpoint, status: :ok)
  end
  
  def edit
    respond_with(@endpoint, status: :ok)
  end
  
  def update
    if @endpoint.update_attributes(params[:endpoint])
      redirect_to endpoint_path(@endpoint)
    else
      redirect_to endpoint_path(@endpoint), alert: @endpoint.errors.full_messages
    end
  end
  
  def refresh
    monitoring_worker = MonitoringWorker.new
    monitoring_worker.url = @endpoint.url
    if monitoring_worker.monitor(@endpoint.url)
      endpoint_is_up
    else
      endpoint_is_down
    end
    respond_to do |format|
      format.html { render :action => :show }
      format.js { render :layout => false }
    end
  end
  
  def remove
    respond_with(@endpoint)
  end
  
  def destroy
    @endpoint.destroy
    
    redirect_to domains_path
  end
  
  # callbacks for IronWorker
  def up
    endpoint_is_up
    head :ok
  end
  
  def down
    endpoint_is_down
    head :ok
  end
  
  private
  
  def assign_endpoint
    @endpoint = Endpoint.find(params[:id])
  end
  
  def assign_endpoint_by_secret_key
    @endpoint = Endpoint.find_by_secret_key(params[:secret_key])
  end
  
  def endpoint_is_up
    @endpoint.up = true
    @endpoint.last_successful_attempt = Time.now
    @endpoint.down_count = 0
    @endpoint.save
  end
  
  def endpoint_is_down
    if @endpoint.down_count < @endpoint.retry_count
      # failure; schedule a retry
      schedule_retry(@endpoint)
    else
      # send notice only on last failed retry
      if @endpoint.user.devices.empty?
        # if user has not configured push messaging, send email
        DomainMailer.notify(@endpoint).deliver
      else
        send_notification
      end
    end
    @endpoint.up = false
    @endpoint.down_count = @endpoint.down_count + 1
    @endpoint.save
  end

  def schedule_retry(endpoint)
    return unless Rails.env.production? # only schedule the worker in production env 
    monitoring_worker = MonitoringWorker.new
    monitoring_worker.url = endpoint.url
    monitoring_worker.secret_key = endpoint.secret_key
    monitoring_worker.css_selector = endpoint.css_selector if endpoint.css_selector
    monitoring_worker.xpath = endpoint.xpath if endpoint.xpath
    monitoring_worker.schedule start_at: Time.now + endpoint.retry_delay.seconds
  end

  def send_notification
    pusher = Grocer.pusher(
      certificate: "config/apns/development.pem",
      gateway: "gateway.sandbox.push.apple.com"
    )
      
    notifications = []
    payload = { endpoint_id: @endpoint.id }
    for device in @endpoint.user.devices
      notification = Grocer::Notification.new(
        device_token: device.token, 
        alert: "Outage Alert", 
        custom: payload
      )
      notifications << notification
    end
    
    notifications.each do |notif|
      pusher.push(notif)
    end
  end
  
end
