class Management::Organizations::EventsController < ManagementController

  def index
    @organization = Organization.find(params[:organization_id])
    @events = @organization.events
    @event = Event.new
  end

  def create
    @organization = Organization.find(params[:organization_id])
    @event = @organization.events.build(params[:event])

    if @event.save
      redirect_to management_organization_events_url(@organization)
    else
      @events = @organizations.events
      render :index
    end
  end
end
