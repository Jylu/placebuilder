class GmailNeighbors
  def self.matches(community, options)
    login = options.delete("login")
    password = options.delete("password")
    return [] unless login.present? and password.present?
    names = GmailNeighbors.get_friends(login, password).map { |f| f["name"] }
    community.residents
      .includes(:user)
      .order("first_name ASC, last_name ASC")
      .where("concat(first_name, ' ', last_name) in (?)", names)
  end

  def self.get_friends(login, password)
    return [] unless login.present? and password.present?
    GmailNeighbors.friends_from_api(login, password).map { |contact|
      {
        "name" => contact[0]
      }
    }
  end

  def self.friends_from_api
    Contacts::GMail(login, password).contacts
  end

  def self.service_name
    "GMail"
  end

  def self.api_endpoint
    "/account/gmail_neighbors"
  end
end
