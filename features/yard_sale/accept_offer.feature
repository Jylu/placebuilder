Feature: Accept an Offer

  Background:
    Given a community
    And a Yard Sale listing
    And I am looking at my inbox

  @javascript
  Scenario: I see an offer for my item that I want to accept
    Given an offer

    When I click "Accept" on the offer

    Then I get a confirmation
    And a confirmation reply is sent to the buyer with pickup instructions

  @javascript
  Scenario: I see an offer for my item that I don't want to accept
    Given an offer

    When I click "Refuse" on the offer

    Then I get a confirmation
    And a refusal reply is sent to the buyer
