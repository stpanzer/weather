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
    cityJson = JSON.parse(connection.read)
    unless cityJson["cod"] == "404"
      newCity = CityWeather.new cityName: name, province: prov, country: country
      newCity.weather = cityJson
      newCity.save

      return newCity
    end
  end
  def geocode_ip(ip)
    ip_url = "http://api.ipinfodb.com/v3/ip-city/?key=8e7a04c4f57900bae6713dbb17866506ebf86f000e983a606d6e8cc7dcf8898d&ip=#{ip}&format=json"
    connection = open(ip_url)
    return JSON.parse(connection.read) 
  end
  def geocode_addr(addr)
    goog_url = "http://maps.googleapis.com/maps/api/geocode/json?"
    address = "address=#{addr}&"
    sensor = "sensor=false"
    connection = open(goog_url+address+sensor)
    return JSON.parse(connection.read)

  end
end
