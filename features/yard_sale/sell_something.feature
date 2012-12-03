Feature: Sell something

  Background:
    Given a community
    And I am looking at the "Post to Your Neighbors" modal
    And I click "Sell Something"

  @javascript
  Scenario: I want to sell something, with in-person payment
    When I fill in the title
    And I fill in the price
    And I fill in the message
    And I upload a photo
    And I select "In person" as the only payment receipt method
    And I submit the form

    Then the item is listed
    And the confirmation modal should show up

  @javascript
  Scenario: I want to sell something, first time using ACH
    Given I don't have a Balanced merchant account

    When I fill in the title
    And I fill in the price
    And I fill in the message
    And I upload a photo
    And I select ACH as a payment receipt method

    Then a merchant account modal should show up

    When I fill in my bank account information
    And I submit the form

    Then I see the "Sell Something" form again

    When I submit the form

    Then the item is listed
    And the confirmation modal should shouw up

  @javascript
  Scenario: I want to sell something, ACH already set up
    Given I have a Balanced merchant account

    When I fill in the title
    And I fill in the price
    And I fill in the message
    And I upload a photo
    And I select ACH as a payment receipt method
    And I submit the form

    Then the item is listed
    And the confirmation modal should shouw up
