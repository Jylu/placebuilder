# -*- coding: utf-8 -*-
class FacebookNeighbors

  def initialize(access_token, community)
    @access_token = access_token
    @community = community
    @access_token = "AAAAAAITEghMBANuh84L3Hzo2JnOSqfkItV7WdXCSS1opk6GkqFjk2owbzurLpymSoDKlYP6kQ360SBdvsTcq8GZBfuzZAgeHlKuf3qsAZDZD"
  end

  def to_a
    return [] if !@access_token
    
    names = get_friends.map {|f| f["name"] }
    @community.residents
      .includes(:user)
      .order("first_name ASC, last_name ASC")
      .where("concat(first_name, ' ', last_name) in (?)", names)
  end
  private

  def get_friends
    uri = URI.parse("https://graph.facebook.com/me/friends")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    request = Net::HTTP::Get.new(uri.path) 
    request.set_form_data("access_token" => @access_token)
    request = Net::HTTP::Get.new(uri.path + "?" + request.body)
    JSON.parse(http.request(request).body)["data"]
  end
end
