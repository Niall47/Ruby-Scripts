Feature: Pull weather data from open weather API
  Scenario: An API request should return IPV4 address
    Given I have started program
    Given The request doesn't error out
    Then A valid IP address should be returned

Scenario: An API request should return a city
  Given I have a IPV4 address
  And no error is detected
  Then A valid city should be returned

Scenario: An API request should return the weather
  Given I have recieved an IP address
  And I have recieved a city
  Then The weather for the city is displayed