module WeatherUtil
  #returns json for city if it exists, otherwise creates a new city
  def get_weather(name, prov, country, *rest)
    if CityWeather.exists? cityName: name, province: prov, country: country
      city = CityWeather.find_by cityName: name, province: prov, country: country
      t = DateTime.now
      if((t - city.updated_at.to_datetime)*24*60) < 10
        return city
      end

    end
    base_url = "http://api.openweathermap.org/data/2.5/forecast/daily?q="
    url = base_url + "#{name}&cnt=7&units=imperial".tr(' ', '_')
    connection = open(url)
    newCity = CityWeather.new cityName: name, province: prov, country: country
    newCity.weather = JSON.parse(connection.read)
    newCity.save
    return newCity    
  end

  def geocode_zip(zip)
    goog_url = "http://maps.googleapis.com/maps/api/geocode/json?"
    address = "address=#{zip}&"
    sensor = "sensor=false"
    connection = open(goog_url+address+sensor)
    return JSON.parse(connection.read)

  end
end
