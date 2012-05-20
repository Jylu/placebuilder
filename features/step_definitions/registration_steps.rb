def log_out
  visit('/users/sign_out')
end

def log_in
  visit '/users/sign_in'
  fill_in "user_email", :with=>@user.email
  fill_in "user_password", :with=>@user.password
  click_button "Sign in"
end

def community_home_page
  "/#{@community.slug}"
end

Given /^a default community exists$/ do
  @community = FactoryGirl.create(:community)
  VCR.use_cassette('user_creation') {
    @user = FactoryGirl.create(:user)
  }
end

Given /^I am on the registration page$/ do
  log_out
  visit community_home_page
end

When /^I click (.*)$/ do |selector|
  find(selector).click
end

Then /^I should see the selector (.*)$/ do |selector|
  find(selector).visible?
end

Then /^I should see the sign in dropdown$/ do
  find("#user_sign_in").find("#sign_in_form").find("form").visible?
end

Given /^I see the sign-in drop-down$/ do
  Given "a default community exists"
  log_out
  Given "I am on the registration page"
  find("#sign_in_button").click
end

When /^I fill in (.*) with "(.*)"$/ do |field_name, value|
  fill_in field_name, :with => value
end

Then /^I should see the main page$/ do

end
