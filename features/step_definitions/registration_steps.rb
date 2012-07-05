def log_out
  visit('/users/sign_out')
end

def log_in
  @user_password = "Password1234"
  @user = FactoryGirl.create(:user, password: @user_password, password_confirmation: @user_password)

  visit '/users/sign_in'
  fill_in "user_email", :with=>@user.email
  fill_in "user_password", :with=>@user_password
  click_button "Sign in"
end

def community_home_page
  if Community.count < 1
    Community.create!(:name => "Test", :slug => "test")
  end
  "/#{Community.all.first.slug}"
end

Given /^a default community exists$/ do
  if Community.count < 1
    Community.create!(:name => 'Test', :slug => 'test')
  end
end

Given /^I am on the registration page$/ do
  log_out
  visit community_home_page
end

When /^I click "(.*)"$/ do |selector|
  find(selector).click
end

Then /^I should see the sign in dropdown$/ do
  find("#user_sign_in").find("#sign_in_form").find("form").visible?
end

Given /^I see the sign in dropdown$/ do
  log_out
  visit community_home_page
  find("#user_sign_in").click
end

When /^I fill in (.*) with (.*)$/ do |field_name, value|
  fill_in field_name, :with => value
end

Then /^I should see the main page$/ do

end

Given /^a logged in user$/ do
  log_in
end
