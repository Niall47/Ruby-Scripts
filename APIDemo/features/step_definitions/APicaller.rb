require 'httparty'

def get_public_ip
  p "Grabbing your public IP from ipify.org"
  response = HTTParty.get('https://api.ipify.org/?format=json')
  error_handler(response)
  my_ip = response['ip']
  @pub_ip = my_ip
  p "Your public IP is #{my_ip}"
  get_city_from_ip(my_ip)
end

def get_city_from_ip(my_ip)
  p 'Grabbing your location based on IP'
  ipstack_call = "http://api.ipstack.com/#{my_ip}?access_key=009636637cb48f813a23d806358cf167"
  response = HTTParty.get(ipstack_call)
  error_handler(response)
  city = response['city']
  @city = city
  p "You must be in #{city}"
  get_weather_from_city(city)
end

def get_weather_from_city(city)
  request = "http://api.openweathermap.org/data/2.5/weather?q=#{city}&APPID=b7dcf01efb72cc1eaca64280c4896fa6&"
  response = HTTParty.get(request)
  error_handler(response)
  tell_me_the_weather(response)
end

def tell_me_the_weather(response)
  r = response
  if response.has_value?("city not found")
    p "city not found"
  elsif response['weather'].empty?
    p "response came back invalid"
  else
    @weather_displayed = true
    city, country, weather, temp, pressure, id = r['name'], r['sys']['country'], r['weather'][0]['main'], r['main']['temp'], r['main']['pressure'], r['id']
    p "Current weather in #{city}, #{country}: #{weather}"
    p "Temperature: #{temp}, Pressure: #{pressure}"
  end
end

def error_handler(response)
  if (response.code != 200)
    @did_we_error_out = true
  end
  case response.code
  when 200
    return response
  when 400
    p 'Bad request Error 400'
  when 401
    p 'Unauthorised! Error 401'
  when 403
    p 'Forbidden! Error 403'
  when 404
    p 'Not Found Error 404'
  when 500
    'Internal server error! Error 500'
  when 502
    'Bad gateway! Error 502'
  when 503
    p 'Service unavailable! Error 503'
  when 504
    p 'Gateway timeout! Error 504'
  else
    p 'Unhandled error'
  end
end

