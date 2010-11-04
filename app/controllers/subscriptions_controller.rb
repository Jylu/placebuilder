class SubscriptionsController < ApplicationController

  layout 'zone'

  def index
    @items = current_user.organizations
  end

  def recommended
    @items = Organization.all
    render :index
  end
  
  def create
    @organization = Organization.find params[:organization_id]
    current_user.organizations << @organization
    flash[:message] = "You've subscribed to #{ @organization.name }."
    redirect_to @organization
  end
  
  def destroy
    @organization = Organization.find params[:organization_id]
    current_user.organizations.delete @organization
    current_user.save
    flash[:message] = "You've unsubscribed from #{ @organization.name }."
    redirect_to @organization
  end
end
