require 'spec_helper'

describe EmailParseController do

  describe ".strip_email_body" do

    let(:separators) { ["^-- \n",
     "^--\n",
     "-----Original\ Message-----",
     "--- Original Message---",
     "_" * 32,
     "On Mar 5, 2011, at 10:51 AM, Falls Church CommonPlace wrote:",
     "From: Max Tilford",
     "Sent from my iPhone",
     "4/10/2011 3:16:02 P.M. Eastern Daylight Time,\n nnotifications@fallschurch.ourcommonplace.com writes:"
                       ] }

    let(:make_email) { lambda {|separator| <<END } }
Hey -- testing a reply!
#{separator}
> > > Reply to CommonPlace 
> or reply to this email to message CommonPlace. > > Want to disable this and/or other e-mails? Click here to manage your subscriptions
END


    it "strips by common separators" do
      results = separators.map do |separator|
        EmailParseController.strip_email_body(make_email.call(separator))
      end
      
      results.each {|r| r.should match "Hey -- testing a reply" }
      results.each {|r| r.should_not match "Hi Peter" }
    end
  end

  let(:community) { mock_model(Community, :id => 1, :slug => "test", :time_zone => "Eastern Time (US & Canada)") }
  let(:user) { mock_model(User, :email => "test@example.com", :community => community, :neighborhood => neighborhood) }

  let(:neighborhood) { mock_model(Neighborhood) }

  before do 
    request.host = "test.example.com"
    stub(User).find_by_email(user.email) { user }
  end


  describe "repliable_id@replies.ourcommonplace.com" do
    let(:fake_post) { mock_model(Post) }
    let(:reply) { mock_model(Reply) }
    before :each do 
      @reply_text = "reply text"
      stub(Reply).create { reply }
      stub(reply).repliable { fake_post }
      mock(controller.kickoff).deliver_reply(reply)
      repliable_id = [fake_post.class.name.underscore, fake_post.id.to_s].join("_")
      stub(Repliable).find(repliable_id) { fake_post }
      post(:parse,
           :from => user.email,
           :recipient => "reply+#{repliable_id}@ourcommonplace.com",
           'stripped-text' => @reply_text,
           :envelope => {:from => "test@example.com"},
           :charsets => '{"text":"UTF-8"}')
    end

    it "creates a reply to the post by the user" do
      Reply.should have_received.create(hash_including(:user => user,
                                                       :repliable => fake_post))
    end

  end
  
  describe "{{community.slug}}@ourcommonplace.com" do

    let(:new_post) { mock_model(Post) } 
    
    it "creates a new post" do
      mock(Post).create(hash_including(:user => user)) { new_post }
      mock(controller.kickoff).deliver_post(new_post)
      @body = "Lorem Ipsum dolor sit amet."
      post(:parse,
           :from => user.email,
           :recipient => "#{community.slug}@ourcommonplace.com",
           'stripped-text' => @body,
           :subject => @body,
           :envelope => {:from => "test@example.com"},
           :charsets => '{"text" : "UTF-8"}')
    end

  end
  
  describe "feed_slug@ourcommonplace.com" do
    let(:new_announcement) { mock_model(Announcement) }
    let(:feed) { mock_model(Feed, :slug => "testfeed", :user_id => user.id, :community_id => community.id) }

    it "posts a new announcement to a feed" do
      mock(controller.kickoff).deliver_announcement(new_announcement)
      mock(Announcement).create(hash_including(:owner => feed)) { new_announcement }
      stub(community).feeds.stub!.find_by_slug( feed.slug ) { feed }
      @body = "Lorem Ipsum dolor sit amet."
      post(:parse,
           :recipient => "#{feed.slug}@ourcommonplace.com",
           :from => user.email,
           'stripped-text' => @body,
           :subject => @body,
           :envelope => { :from => "test@example.com"},
           :charsets => '{"text" : "UTF-8"}')

    end
  end
end
