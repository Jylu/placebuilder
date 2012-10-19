class FlagNotification < MailBase

  def initialize(warn_id)
    @warning = Warning.find(warn_id)
    @user = @warning.warnable.user
    @warnable = @warning.warnable
  end

  def user
    @user
  end

  def community
    @user.community
  end

  def subject
    "#{user_name} was flagged"
  end

  def short_user_name
    @user.first_name
  end

  def user_name
    @user.name
  end
end
