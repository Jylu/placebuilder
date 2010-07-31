require 'spec_helper'

describe ThreadMembership do
  before(:each) do
    @user = Factory :user
    @user2 = Factory :user
    @thread = Thread.new
    @thread.contributers << @user
    @thread.contributers << @user
    @thread_membership = @user.thread_memberships(:conditions => {:thread_id 
  end

  it "should be unread initially" do
    @user.thread_member
    
end
