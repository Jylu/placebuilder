class UsersController < CommunitiesController


  def index
    @users = User.all
    respond_to do |format|
      format.json
      format.html
    end
  end


end
