class SiteController < ApplicationController

  layout 'application'

  def privacy ; end

  def terms ; end

  def info
    unless params[:locate] == "false"
      # Get user's location from IP Address
      # Send them to the right community's about page
      closest_community = Community.all.map do |community|
        {
          distance: CoordinateDistance.distance(
              request.location,
              {
                latitude: community.latitude,
                longitude: community.longitude
              }),
          slug: community.slug
        }
      end.sort_by { |h| h[:distance] }.first
      redirect_to "/#{closest_community[:slug]}/about"
    end
    render layout: nil
  end
end
