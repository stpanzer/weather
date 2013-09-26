module WeatherUtil
  #returns json for city if it exists, otherwise creates a new city
  def get_weather(rest)
    if CityWeather.exists? rest
      city = CityWeather.find_by rest
      t = DateTime.now
      if((t - city.updated_at.to_datetime)*24*60).to_i < 10
        return city
      end

    end
    base_url = "http://api.openweathermap.org/data/2.5/forecast/daily?q="
    query = ""
    if(rest[:cityName])
      query << rest[:cityName]+","
    elsif rest[:area]
      query << rest[:area]+","
    end
    subhash = rest.select{|key, value| ![:area, :cityName].include? key}
    subhash.each_value do |key|
      if key
        query << key+","
      end
    end
    url = base_url + "#{CGI.escape query}&cnt=7&units=imperial".tr(' ', '_')
    connection = open(url)
    cityJson = JSON.parse(connection.read)
    if ! (cityJson["cod"] == "404") and !city
      newCity = CityWeather.new rest
      newCity.weather = cityJson
      newCity.save
      return newCity
    elsif city
      city.weather = cityJson
      city.save
      return city
    end
  end
  def get_bg_attribution(status)
    url = "background/"+status
    if status == "rain"
      return {url: url, attr: "pennacook", attr_url: "http://www.flickr.com/photos/pennacook/"}
    elsif status == "clouds"
      return {url: url, attr: "Esparta Palma", attr_url: "http://www.flickr.com/photos/esparta"}
    elsif status == "clear"
      return {url: url, attr: "Elliott Brown", attr_url: "http://www.flickr.com/photos/ell-r-brown"}
    elsif status == "snow"
      return {url: url, attr: "Lee Haywood", attr_url: "http://www.flickr.com/photos/leehaywood/"}
    else
      return nil
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
