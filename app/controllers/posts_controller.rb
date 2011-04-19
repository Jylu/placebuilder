class PostsController < CommunitiesController
  helper_method :post

  load_and_authorize_resource

  def index
    @items = current_community.posts(:all, :limit => 30)
  end

  def new
  end

  def create
    @post.user = current_user
    @post.community = current_user.community
    if @post.save
      puts @post.inspect
      post_params = params[:post]
      if (post_params[:post_to_facebook] == "1")
      #  current_user.access_token.post(
      #    "/" + current_user.facebook_uid.to_s + "/feed/", 
      #    :message => "I just posted to my community on CommonPlace!", 
      #    :picture => root_url(:subdomain => current_community.slug) + "images/logo-pin.png",
      #    :link => post_url(@post, :subdomain => current_community.slug),
      #    :name => "CommonPlace " + current_community.name,
      #    :caption => "CommonPlace for " + current_community.name,
      #    :description => "DESCRIPTION")
      end
      current_neighborhood.users.receives_posts_live.each do |user|
        Resque.enqueue(PostNotification, post.id, user.id) if @post.user != user
      end
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit ; end

  def update
    if @post.update_attributes(params[:post])
      redirect_to post_url(@post)
    else
      render :edit
    end
  end
  
  def destroy
    if can? :destroy, @post
      if @post.destroy
        flash[:message] = "Post Deleted!"
        redirect_to posts_path
      else
        render :new
      end
    end
  end

  def show
  end

  def uplift
    if can?(:uplift, @post)
      original_neighborhood = @post.neighborhood
      @post.sent_to_community = true
      @post.save
      current_community.neighborhoods.reject {|n| n == original_neighborhood }.
        each do |n|
        n.users.receives_posts_live.each do |user|
          Resque.enqueue(PostNotification, @post.id, user.id)
        end
      end
    end
    redirect_to root_url
  end
  
  protected 
  def post
    @post 
  end
    
end
