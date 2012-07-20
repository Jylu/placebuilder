Warden::Manager.after_authentication do |user, auth, opts|
  user.track_logged_in
end
