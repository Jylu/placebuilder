class API
  class Ads < Postlikes

    # This api inherits from the Postlikes api, where most of it's methods
    # are defined. It overrides some of Postlikes's helpers in order
    # to work specifically with Posts.

    helpers do

      # Returns the Postlike klass
      def klass
        Ad
      end

      # Set the transaction's attributes using the given request_body
      #
      # Request params:
      #  body -
      #
      # Returns true on success, false otherwise
      def update_attributes
        find_postlike.update_attributes(
          body:  request_body["body"]
        )
      end

    end
   end
end
