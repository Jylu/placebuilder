Feature: Make an Offer

  Background:
    Given a community
    And I am looking at the Marketplace listings

  @javascript
  Scenario: I see an item I like with one payment option
    Given an item with only one payment method

    When I click "Buy" on the item listing

    Then I see the contact form

  @javascript
  Scenario: I see an item with multiple options
    Given an item with multiple payment options

    When I click "Buy" on the item listing

    Then I see a modal to select my desired payment option
    And I see information about paying by credit

  @javascript
  Scenario: I choose you, Pay in person!
    Given an item with multiple payment options
    And I see the payment option modal

    When I select "In person"

    Then I see a contact form

  @javascript
  Scenario: I choose you, Pay in person!
    Given an item with multiple payment options
    And I see the payment option modal
    And I don't have a Balanced credit card account

    When I select ACH

    Then I see a contact form
    And I see a credit card form

  @javascript
  Scenario: I choose you, Pay in person!  Again.
    Given an item with multiple payment options
    And I see the payment option modal
    And I do have a Balanced credit card account

    When I select ACH

    Then I see a contact form
    And I don't see a credit card form

  @javascript
  Scenario: I fill out an offer, no credit form
    Given an item with "In person" payment
    And I see the contact form

    When I fill out the contact form
    And I submit the form

    Then my offer message is sent to the seller

  @javascript
  Scenario: I fill out an offer, "ACH", first time
    Given an item with "ACH" payment
    And I see the contact form

    When I fill out the contact form
    And I fill out the credit card data
    And I submit the form

    Then my offer message is sent to the seller
    And I have a credit card on file
