Feature: Registering to the website

  @javascript
  Scenario: I want to create a commonplace account
    Given a default community exists
    Given I am on the registration page
    When I fill in "Full Name" with Andrew McLovin
    And I fill in "Your Email" with mclovin@gmail.com
    And I fill in "New Password" with test
    And I press "Register Now!"
    And I wait for AJAX

    Then I should see "We won't share your address with anyone"

