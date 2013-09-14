module WeatherUtil
  def get_weather(name, prov, country)
    base_url = "http://api.openweathermap.org/data/2.5/forecast/daily?q="
    url = base_url + "#{name}&cnt=7&units=imperial".tr(' ', '_')
    connection = open(url)
    return JSON.parse(connection.read) 
  end

  def geocode_zip(zip)
    goog_url = "http://maps.googleapis.com/maps/api/geocode/json?"
    address = "address=#{zip}&"
    sensor = "sensor=false"
    connection = open(goog_url+address+sensor)
    return JSON.parse(connection.read)

  end
end
