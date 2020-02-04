Given(/^I have started program$/) do
  get_public_ip
  @did_we_error_out = false
  end

Given(/^The request doesn't error out$/) do
  expect(@did_we_error_out == false)
end

Then(/^A valid IP address should be returned$/) do
  expect(@pub_ip != nil)
  expect(@pub_ip.length > 10 && @pub_ip.length < 17)
end

Given(/^I have a IPV4 address$/) do

end

And(/^no error is detected$/) do
  expect(@did_we_error_out == false)
end

Then(/^A valid city should be returned$/) do
  expect(@city != nil)
  #city_length = @city.length
  #p city_length.to_s
  #expect(@pub_ip.length > 3 && @pub_ip.length < 25)
end


Given(/^I have recieved an IP address$/) do

end

And(/^I have recieved a city$/) do

end

Then(/^The weather for the city is displayed$/) do
  expect(@weather_displayed = true)
end