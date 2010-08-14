class PostsController < CommunitiesController
  before_filter :load_post

  filter_access_to :all

  caches_action :show
  def index
    @posts = Post.all
    respond_to do |format|
      format.json
      format.html
    end
  end

  def new
    respond_to do |format|
      format.json
    end
  end
  
  def create
    respond_to do |format|
      if @post.save
        format.html { redirect_to root_url }
        format.json         
      else
        format.json { render 'new' }
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json
    end
  end
  
  def destroy
    if @post.destroy
      flash[:win] = "Post deleted."
    else
      flash[:fail] = "There was an error deleting your post--please try again."
    end
    redirect_to root_url
  end

  protected 
  
  def load_post
    @post = if params[:id]
              Post.find(params[:id])
            elsif params[:post]
              Post.new(params[:post].merge(:user => current_user))
            else 
              Post.new(:user => current_user)
            end
  end
    
end
