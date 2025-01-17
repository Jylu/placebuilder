class API

  class Base < Sinatra::Base

    enable :raise_errors
    enable :logging
    enable :dump_errors

    helpers do

      # A helper method that halts with 401 if the test fails.
      #
      # If the current_user is an admin we don't bother running the test.
      #
      # Arguments
      #   test - a symbol, one of [:public, :authenticated, :community_member,
      #          :owner, :thread_member, :admin]
      #   arg - an optional argument that may be used in the test
      #
      # Halts with 401 if the test fails. No return value
      def control_access(test, arg = nil)
        return if test == :public
        halt 401 unless warden.authenticated?(:user)
        return if current_user.admin?
        accessible = case test
                     when :authenticated then true
                     when :community_member then current_user.community == arg
                     when :thread_member then arg.thread_member?(current_user)
                     when :owner then current_user == arg.user
                     when :admin then current_user.admin?
                     else false
                     end
        halt 401 unless accessible
      end

      # Returns the currently authenticated user (or nil)
      def current_user
        @_user ||= warden.user(:user)
      end

      # Helper for accessing env["warden"]
      def warden
        env["warden"]
      end

      # Parses and returns the request body as json
      def request_body
        @_request_body ||= JSON.parse(request.body.read.to_s)
      end

      # renders the argument as json
      #
      # Args:
      #   thing - a thing that is serializable by Serializer
      #
      # Returns a JSON string
      def serialize(thing)
        Serializer::serialize(thing).to_json
      end

      # Returns the desired page number based on params[:page]
      #
      # The default page is 0
      def page
        (params[:page] || 0).to_i
      end

      # Returns the desired per_page limit based on params[:limit]
      #
      # The default is limit is 25
      def limit
        (params[:limit] || 25).to_i
      end

      # Applys pagination to an ActiveRecord query based on #limit and #page
      #
      # Args:
      #   scope - an ActiveRecord query
      #
      # Returns a new ActiveRecord query with limit and offset applied
      def paginate(scope)
        limit.to_i == 0 ? scope : scope.limit(limit).offset(limit * page)
      end

      # Returns a KickOff object, used as an interface to kickoff
      # asynchronous jobs
      def kickoff
        request.env["kickoff"] ||= KickOff.new
      end

      # Gets the last time a ActiveRecord query (of PostLikes) was modified (for
      # the purposes of caching
      #
      # Args:
      #   scope - An ActiveRecord query for Posts, Events, Announcements, GroupPosts
      #
      # Returns a DateTime object
      def last_modified_by_replied_at(scope)
        # sets last modified header for this request to that of the newest record
        last_modified_item = scope.unscoped.order("GREATEST(replied_at, updated_at) DESC").first
        last_thank = Thank.order("created_at DESC").first

        last_modified([
            last_modified_item.try(:replied_at),
            last_modified_item.try(:updated_at),
            last_thank.try(:created_at),
            Date.today.beginning_of_day].compact.max)
      end

      # Creates a Thank for a given Thankable
      #
      # Args:
      #   scope - A Thankable class (Reply, Post, Event, Announcement, GroupPost)
      #   id - The id of the Thankable
      #
      # When the thank is successfully created, returns 200 and the serialized thank
      # When the thank is already exists, returns 400
      def thank(scope, id)
        post = scope.find(id)

        control_access :community_member, post.community

        halt [400, "errors: already thanked"] unless post.thanks.index { |t| t.user.id == current_user.id } == nil
        thank = Thank.new(:user_id => current_user.id,
                          :thankable_id => id,
                          :thankable_type => scope.to_s)
        if thank.save
          kickoff.deliver_thank_notification(thank.id)
          if scope == Reply
            serialize scope.find(id).repliable
          else
            serialize scope.find(id)
          end
        else
          [400, "errors"]
        end
      end

      # Creates a Warning for a given Warnable
      #
      # Args:
      #   scope - A Warnable class (Reply, Post, Event, Announcement, GroupPost)
      #   id - The id of the Warnable
      #
      # When the warning is successfully created, returns 200 and the serialized thank
      # When the warning is already exists, returns 400
      def flag(scope, id)
        post = scope.find(id)

        control_access :community_member, post.community

        halt [400, "errors: already flagged"] unless post.warnings.index { |t| t.user.id == current_user.id } == nil
        warning = Warning.new(:user_id => current_user.id,
                              :warnable_id => id,
                              :warnable_type => scope.to_s)

        if warning.save
          kickoff.deliver_flag_notification(warning.id)
          if scope == Reply
            serialize scope.find(id).repliable
          else
            serialize scope.find(id)
          end
        else
          [400, "errors"]
        end
      end

    end

    before do
      # ?
      cache_control :public, :must_revalidate, :max_age => 0

      # Sets the outgoing content type to application/json
      content_type :json
    end

    after do

      # Sunspot::Rails commits the Sunspot session (indexes everything) at
      # the end of each request. When we hit the api, that doesn't get triggered
      # so we're doing it here. See
      # https://github.com/sunspot/sunspot/blob/master/sunspot_rails/lib/sunspot/rails/request_lifecycle.rb
      # for details
      Sunspot.commit_if_dirty

    end

  end

end
