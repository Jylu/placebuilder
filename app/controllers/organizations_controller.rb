class OrganizationsController < CommunitiesController
  
  def index
    @subscribed_organizations = current_user.organizations
    @suggested_organizations = []
    @community_organizations = current_community.organizations.all(:conditions => ["id NOT IN (?)", @subscribed_organizations + @suggested_organizations + [0]])
    respond_to do |format|
      format.json
      format.html
    end
  end

  def show
    @organization = Organization.find params[:id]
    @events = Event.find(:all, :conditions => ["organization_id = ?", @organization.id])
    @subscribers = @organization.subscribers

    respond_to do |format|
      format.json 
      format.html { render :layout => 'application' }
    end
  end

  def new
    @organization = Organization.new
    respond_to do |format|
      format.json 
    end
  end
  
end
