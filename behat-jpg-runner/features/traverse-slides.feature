Feature: traverse all the slides of the presentation

  Scenario: As a user, I want to be able to see all the slides of a presentation
    When I load the presentation
    Then I can go to the next slide until there are slides left
