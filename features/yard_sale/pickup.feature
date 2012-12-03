Feature: Pick up an item

  Background:
    Given a community
    And an offer that was accepted by a seller

  @javascript
  Scenario: I am the buyer
    Given I am the buyer

    When I look at my inbox

    Then I see a confirmation reply with pickup information
    And I see info about resolving pickup issues

  @javascript
  Scenario: I am the seller
    Given I am the seller

    When I look at my inbox

    Then I see the confirmation message with pickup information
    And I see a link to confirm successful pickup

  @javascript
  Scenario: Seller confirms pickup
    Given I am the seller
    And I am looking at my inbox

    When I click the link to confirm pickup

    Then a message is sent to the buyer asking for confirm
    And electronic funds are escrowed

  @javascript
  Scenario: Buyer confirms pickup
    Given I am the buyer
    And the seller has confirmed pickup
    And I am looking at my inbox

    When I click the link to confirm pickup

    Then a final confirmation is added to the thread
    And escrow funds are released

  @javascript
  Scenario: Buyer lets confirmation window expire
    Given I am the buyer
    And the seller has confirmed pickup

    When the confirmation window is over

    Then a final confirmation is added to the thread
    And escrow funds are released
