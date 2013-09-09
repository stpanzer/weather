module WeatherUtil
  def get_weather(name, prov, country)
    base_url = "http://api.openweathermap.org/data/2.5/forecast/daily?q="
    url = base_url + "#{name}&cnt=7&units=imperial".tr(' ', '_')
    return JSON.parse(open(url).read) 
  end
end
