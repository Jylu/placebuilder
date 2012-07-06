class API
  class Communities < Base

    helpers do

      # Finds the community by params[:id] or returns 404
      def find_community
        @community ||= case params[:id]
                       when /^\d+/
                         Community.find_by_id(params[:id])
                       else
                         Community.find_by_slug(params[:id])
                       end
        @community || (halt 404)
      end

      # Performs a Sunspot search for the given PostLike(s), params, and community
      #
      # Returns a JSON string of the results
      def search(klass, params, community_id)
        keywords = phrase(params["query"])
        search = Sunspot.search(klass) do
          keywords keywords
          paginate(:page => params["page"].to_i + 1)
          with(:community_id, community_id)
          yield(self) if block_given?
        end
        serialize(search)
      end

      # Performs a search like #search, but ordered most recent first
      #
      # Returns a JSON string of the results
      def chronological_search(klass, params, community_id)
        keywords = phrase(params["query"])
        search = Sunspot.search(klass) do
          keywords keywords
          order_by(:created_at, :desc)
          paginate(:page => params["page"].to_i + 1)
          with(:community_id, community_id)
          yield(self) if block_given?
        end
        serialize(search)
      end

      # Why is this not scoped by community? (appears to be intentional)
      def auth_search(klass, params)
        keywords = phrase(params["query"])
        search = Sunspot.search(klass) do
          keywords keywords
          order_by(:created_at, :desc)
          paginate(:page => params["page"].to_i + 1)
          yield(self) if block_given?
        end
        serialize(search)
      end

      # Returns a chronological list of the given classes for the given community
      def chronological(klass, params, community_id)
        search = Sunspot.search(klass) do
          order_by(:created_at, :desc)
          paginate(:page => params["page"].to_i + 1, :per_page => params["limit"])
          with(:community_id, community_id)
        end
        serialize(search)
      end

      # Returns the JSON results of an Event search in the given community
      def event_search(params, community_id)
        keywords = phrase(params["query"])
        search = Sunspot.search(Event) do
          keywords keywords
          order_by(:date, :desc)
          paginate(:page => params["page"].to_i + 1)
          with(:community_id, community_id)
          yield(self) if block_given?
        end
        serialize(search)
      end

      # Turns a string into a array to be used as a search phrase
      #
      # Example:
      #   phrase(%{foo "baz baz" qux})
      #   # => ["foo", "\"bax baz\"", "qux"]
      #
      # Note: is returning those escaped quotes proper behavior?
      def phrase(string)
        string.split('"').each_with_index.map { |object, i|
          i.odd? ? %{"#{object}"} : object.split(" ")
        }.flatten
      end

      def filter_users_by_tag(tag,haveornot)
        @resident=false
        case tag
              when "post"
                @ids=Post.all.map {|a| a.user_id}.uniq
              when "email"
                @emails=SentEmail.where(:status=>"opened").map {|a| a.recipient_email}.uniq
                @ids=User.where(:email=>@emails).map &:id
              when "sitevisit"
                @ids=SiteVisit.all.map {|a| a.commonplace_account_id}.uniq
              when "announcement"
                @ids=Announcement.where(:owner_type=>"User").map {|a| a.owner_id}.uniq
                @announcements=Announcement.where(:owner_type=>"Feed").map {|a| a.owner_id}.uniq
                @ids+=Feed.where(:id=>@announcements).map {|a|a.user_id}.uniq
              when "event"
                @ids=Event.where(:owner_type=>"User").map {|a| a.owner_id}.uniq
                @events=Event.where(:owner_type=>"Feed").map {|a| a.owner_id}.uniq
                @ids+=Event.where(:id=>@events).map {|a|a.user_id}.uniq
              when "reply"
                @ids=Reply.all.map {|a| a.user_id}.uniq
              when "replied"
                @postsids=Reply.all.map {|a| a.repliable_id}.uniq
                @ids=Post.where(:id=>@postsids).map {|a| a.user_id}.uniq
              when "invite"
                @ids=Invite.all.map {|a| a.inviter_id}.uniq
              else
                @ids=Flag.where(:name=>tag).map &:resident_id
                @resident=true
          end
          @ids.uniq!
          if !@resident
            if haveornot=="yes"
              User.where(:id=>@ids)
            else
              if @ids.empty?
                User.all
              else
                User.where("id not in (?)",@ids)
              end
            end
          else
            if haveornot=="yes"
              Resident.where(:id=>@ids)
            else
              if @ids.empty?
                Resident.all
              else
                Resident.where("id not in (?)",@ids)
              end
            end
          end
      end

      def order_users_by_time_of_tag(tag)
        @resident=false
        case tag
              when "post"
                @ids=Post.order("created_at DESC").map {|a| a.user_id}.uniq
              when "email"
                @emails=SentEmail.sort("created_at DESC").where(:status=>"opened").map {|a| a.recipient_email}.uniq
                @ids=User.where(:email=>@emails).map &:id
              when "sitevisit"
                @ids=SiteVisit.sort("created_at DESC").map {|a| a.commonplace_account_id}.uniq
              when "announcement"
                @ids=Announcement.order("created_at DESC").where(:owner_type=>"User").map {|a| a.owner_id}.uniq
                @announcements=Announcement.order("created_at DESC").where(:owner_type=>"Feed").map {|a| a.owner_id}.uniq
                @ids+=Feed.where(:id=>@announcements).map {|a|a.user_id}.uniq
              when "event"
                @ids=Event.order("created_at DESC").where(:owner_type=>"User").map {|a| a.owner_id}.uniq
                @events=Event.order("created_at DESC").where(:owner_type=>"Feed").map {|a| a.owner_id}.uniq
                @ids+=Event.order("created_at DESC").where(:id=>@events).map {|a|a.user_id}.uniq
              when "reply"
                @ids=Reply.order("created_at DESC").map {|a| a.user_id}.uniq
              when "replied"
                @postsids=Reply.order("created_at DESC").map {|a| a.repliable_id}.uniq
                @ids=Post.where(:id=>@postsids).map {|a| a.user_id}.uniq
              when "invite"
                @ids=Invite.order("created_at DESC").map {|a| a.inviter_id}.uniq
              else
                @ids=Flag.where(:name=>tag).order("created_at DESC").map &:resident_id
                @resident=true
          end
          @ids.uniq!
          @users=nil
          if !@resident          
            @users=User.where(:id=>@ids[0])
            for @k in 1..@ids.size-1 do
              if User.find(@ids[@k])
                @users << User.find(@ids[@k])
              end
            end
          else
            @users=Resident.where(:id=>@ids[0])
            for @k in 1..@ids.size-1 do
              if Resident.find(@ids[@k])
                @users << Resident.find(@ids[@k])
              end
            end
          end
          @users.uniq!
          serialize(@users)
      end

      def order_users_by_quantity_of_tag(tag)
        @need=false
        case tag
          when "post"
            @users=User.order("posts_count DESC")
          when "reply"
            @users=User.order("replies_count DESC")
          when "sitevisit"
            @users=User.order("sign_in_count DESC")
          when "announcement"
            @users=User.order("announcements_count DESC")
          when "feed"
            @users=User.order("feeds_count DESC")
          when "replied"
            @users=User.order("replied_count DESC")
          when "invite"
            @users=User.order("invite_count DESC")
          when "event"
            @users=User.order("events_count DESC")
        end
        @users.uniq!
        serialize(@users)
      end
    end

    # Returns the serialized community, found by slug or id
    get "/:id" do
      control_access :public

      serialize find_community
    end

    # Returns the serialized community wire
    #
    # Requires community membership
    get "/:id/wire" do
      control_access :community_member, find_community

      serialize find_community.wire
    end

    # Returns the community's residents list
    #
    # Requires community membership
    #
    # Query params:
    #   query - query to search residents by
    #   limit - the page limit
    #   page - the page
    get "/:id/residents" do
      control_access :community_member, find_community

      residents = find_community.residents.includes(:user)
      residents = paginate(residents)
      residents = residents.order("first_name ASC, last_name ASC")
      if params["query"].present?
        terms = params["query"].split(" ").join(" | ")
        residents = residents.where(<<CONDITION,terms)
upper(first_name || ' ' || last_name)::tsvector @@ tsquery(upper(?))
CONDITION
      end
      serialize residents
    end

    # Returns community's resident files
    #
    # Requires admin
    #
    # Query params:
    #   with - find files tagged with tags in this list
    #   without - but not tagged with tags in this list
    get "/:id/files" do
      control_access :admin
      if params[:search]=="filter"
        if !params[:order]
          if params[:tag].length>1
            @users=filter_users_by_tag(params[:tag][0],params[:have][0])
            @final=@users&filter_users_by_tag(params[:tag][1],params[:have][1])
            for @k in 2..params[:tag].size-1 do
                @final=@final&filter_users_by_tag(params[:tag][@k],params[:have][@k])
            end
            serialize(@final)
          else
            puts params[:have][0]
            serialize(filter_users_by_tag(params[:tag][0],params[:have][0]))
          end
        else
          if params[:order]=="time"
             order_users_by_time_of_tag(params[:tag])
          else
             order_users_by_quantity_of_tag(params[:tag])
          end
        end
      else
      serialize(Sunspot.search(Resident) do
          paginate :page => 1, :per_page => 9001
          order_by :last_name
          all_of do
            with :community_id, params[:id]
            Array(params[:with].try(:split, ",")).each do |w|
              with :tags, w
            end
            Array(params[:without].try(:split, ",")).each do |w|
              without :tags, w
            end
          end
        end)
      end
    end


    # Add a new resident
    #
    # Requires admin
    #
    post "/:id/files/newresident" do
      control_access :admin

      r = find_community.residents.create(:first_name => request_body['first_name'],
                                      :last_name => request_body['last_name'],
                                      :email => request_body['email'],
                                      :phone => request_body['phone'],
                                      :organization => request_body['organization'],
                                      :position => request_body['position'],
                                      :notes => request_body['notes'],
                                      :address => request_body['address'],
                                      :sector_tags => request_body['sector_tags'],
                                      :type_tags => request_body['type_tags'],
                                      :manually_added => true
                                      )

      r.manually_added


    end

    # Updates a community resident file
    #
    # Requires admin
    #
    # Request params:
    #   email - set the file's email to this (optional)
    #   address - set the files address to this (optional)
    put "/:id/files/:file_id" do
      control_access :admin

      Resident.find(params[:file_id]).update_attributes(
        request_body.slice("email", "address","phone","organization","notes","position","first_name","last_name","sector_tags","type_tags")
      )
    end

    # Returns a specific resident file
    #
    # This is being called somewhere in the organizer app,
    # though I'm not sure where.
    # This is here to stop the 404 error, though it seems like
    # a harmless error
    get "/:id/files/:file_id" do
      control_access :admin

      Resident.find(params[:file_id])
    end

    # Add a log to a community resident file
    #
    # Requires admin
    #
    # Request params:
    #   date - the date the logged activity occured on
    #   text - the activity description
    #   tags - any tags related to the log
    post "/:id/files/:file_id/logs" do
      control_access :admin

      Resident.find(params[:file_id]).add_log(
        request_body['date'],
        request_body['text'],
        [])
      200
    end

    # Add tags to a community resident file
    #
    # Requires admin
    #
    # Request params:
    #   tags - the tags to add
    post "/:id/files/:file_id/tags" do
      control_access :admin

      Resident.find(params[:file_id]).add_tags(params[:tags])
      200
    end

    # Create a post in the community
    #
    # Requires community membership
    #
    # Request params:
    #   title - the post subject
    #   body - the post body
    #   category - the post category
    #
    # When successful we kick off a notification job and return
    # the serialized post
    # When unsuccessful we return a 400 response
    post "/:id/posts" do
      control_access :community_member, find_community

      post = Post.new(:user => current_user,
                      :community_id => find_community.id,
                      :subject => request_body['title'],
                      :body => request_body['body'],
                      :category => request_body["category"])
      if post.save
        kickoff.deliver_post(post)
        serialize(post)
      else
        [400, "errors"]
      end
    end

    # Create a announcement in the community
    #
    # Requires community membership
    #
    # Request params:
    #   title - the announcement subject
    #   body - the announcement body
    #   group_ids - the announcement groups
    #   feed - the feed that is creating the announcement
    #
    # When successful we kick off a notification job and return
    # the serialized announcement
    # When unsuccessful we return a 400 response
    post "/:id/announcements" do
      control_access :community_member, find_community

      announcement = Announcement.new(:owner => Feed.find(request_body['feed']),
                                      :subject => request_body['title'],
                                      :body => request_body['body'],
                                      :community_id => find_community.id,
                                      :group_ids => request_body["groups"])

      if announcement.save
        kickoff.deliver_announcement(announcement)
        serialize(announcement)
      else
        [400, "errors"]
      end
    end

    # Create an event in the community
    #
    # Requires community membership
    #
    # Request params:
    #   title - the event name
    #   about - the event description
    #   date - the event date
    #   start_time - when it starts (optional)
    #   end_time - when it ends (optional)
    #   venue - where it is (optional)
    #   address - street address (optional)
    #   tag_list - tags (optional)
    #   group_ids - relevant groups (optional)
    #
    # Returns serialized event if save is succesfull
    # Returns 400 if unsuccessfull

    post "/:id/events" do
      control_access :community_member, find_community

      event = Event.new(:owner => current_user,
                        :name => request_body['title'],
                        :description => request_body['about'],
                        :date => request_body['date'],
                        :start_time => request_body['start'],
                        :end_time => request_body['end'],
                        :venue => request_body['venue'],
                        :address => request_body['address'],
                        :tag_list => request_body['tags'],
                        :community_id => find_community.id,
                        :group_ids => request_body['groups']
      )
      if event.save
        serialize(event)
      else
        [400, "errors"]
      end
    end

    # Returns a list of completed versions of the address
    #
    # term - the term to find auto-completed
    get "/:id/address_completions" do
      serialize(find_community.street_addresses
      .where("address ILIKE ?", "%#{params[:term]}%").pluck(:address))
    end

    # Returns the community's posts, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/posts" do
      control_access :community_member, find_community

      last_modified_by_replied_at(Post)

      if params["query"].present?
        chronological_search(Post, params, find_community.id)
      else
        serialize(paginate(find_community.posts.includes(:user, :replies)))
      end
    end

    # Returns the community's posts and group_posts, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/posts_and_group_posts" do
      control_access :community_member, find_community

      if params["query"].present?
        chronological_search([Post, GroupPost], params, find_community.id)
      else
        chronological([Post, GroupPost], params, find_community.id)
      end
    end

    # Returns the community's posts in a category, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/posts/:category" do
      control_access :community_member, find_community

      last_modified_by_replied_at(Post)

      if params["query"].present?
        chronological_search(Post, params, find_community.id) do |search|
          search.with(:category, params[:category])
        end
      else
        serialize(paginate(
            find_community.posts.
            where(:category => params[:category]).
            includes(:user, :replies)
            ))
      end
    end

    # Returns the community's events, possibly a search result
    get "/:id/events" do
      control_access :community_member, find_community

      last_modified_by_replied_at(Event)

      if params["query"].present?
        event_search(params, find_community.id) do |search|
          search.with(:date).greater_than(Time.now.beginning_of_day)
        end
      else
        serialize(paginate(find_community.events.upcoming.
                             includes(:replies).reorder("date ASC")))
      end
    end

    # Returns the community's announcements, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/announcements" do
      control_access :community_member, find_community

      last_modified_by_replied_at(Announcement)

      if params["query"].present?
        chronological_search(Announcement, params, find_community.id)
      else
        serialize(paginate(find_community.announcements.
                             includes(:replies, :owner).
                             reorder("GREATEST(replied_at,created_at) DESC")))
      end
    end

    # Returns the community's group posts, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/group_posts" do
      control_access :community_member, find_community

      last_modified_by_replied_at(GroupPost)

      if params["query"].present?
        chronological_search(GroupPost, params, find_community.id)
      else
        serialize(paginate(GroupPost.order("group_posts.replied_at DESC").
                             includes(:group, :user).
                             where(:groups => {:community_id => find_community.id})))
      end
    end

    # Returns the community's feeds, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/feeds" do
      control_access :community_member, find_community

      if params["query"].present?
        search(Feed, params, find_community.id)
      else
        scope = find_community.feeds.reorder("name ASC")
        serialize(paginate(scope))
      end
    end

    # Returns the community's groups, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/groups" do
      control_access :community_member, find_community

      if params["query"].present?
        search(Group, params, find_community.id)
      else
        serialize(paginate(find_community.groups.reorder("name ASC")))
      end
    end

    # Returns the community's users, possibly a search result
    #
    # Query params:
    #  query - a query to search with (optional)
    get "/:id/users" do
      control_access :community_member, find_community

      if params["query"].present?
        if current_user.admin
          auth_search(User, params) # what is auth_search for ?
        else
          search(User, params, find_community.id)
        end
      else
        scope = find_community.users.reorder("last_name ASC, first_name ASC")
        serialize(paginate(scope))
      end
    end

    # Returns the community's featured feeds
    get "/:id/feeds/featured" do
      control_access :community_member, find_community

      scope = find_community.feeds.featured.order("name ASC")
      serialize paginate(scope)
    end

    # Returns the community's user count
    get "/:id/user_count" do
      control_access :community_member, find_community

      serialize(find_community.users.count)
    end

    # Returns a search on [Feed, Group, User]
    #
    # Query params:
    #   query = the query to search with
    get "/:id/group-like" do
      control_access :community_member, find_community

      # only search
      halt [200, {}, "[]"] if params["query"].blank?

      if current_user.admin
        auth_search([Feed, Group, User], params)
      else
        search([Feed, Group, User], params, find_community.id)
      end
    end

    # Gets all postlikes for a community, possibly a search
    #
    # Query params:
    #   query = the query to search with (optional)
    get "/:id/post-like" do
      control_access :community_member, find_community

      if params["query"].present?
        chronological_search([Announcement, Event, Post, GroupPost], params, find_community.id)
      else
        chronological([Announcement, Event, Post, GroupPost], params, find_community.id)
      end
    end

    # Sends an invite
    #
    # Request params:
    #   emails - Emails to invite
    #   message - A personal message to send
    post "/:id/invites" do
      control_access :community_member, find_community

      kickoff.deliver_user_invite(request_body['emails'],
                                  current_user,
                                  request_body['message'])
      [ 200, {}, "" ]
    end

    # Sends a share
    #
    # Request params:
    #   data_type - shared Postlike class
    #   id - id of the shared Postlike
    #   email - email to share to
    post "/:id/shares" do
      control_access :community_member, find_community

      scope = request_body['data_type'].chop.camelize.constantize
      item = scope.find(request_body['id'])
      kickoff.deliver_share_notification(current_user, item, request_body['email'])
      [ 200, {}, "" ]
    end

    # Sends a question to us
    #
    # Request params:
    #  email - email of the question asker
    #  message - the question
    #  name - name of the question asker
    post "/:id/questions" do
      control_access :community_member, find_community

      kickoff.deliver_admin_question(request_body['email'],
                                     request_body['message'],
                                     request_body['name'])
      [ 200, {}, "" ]
    end

  end
end
