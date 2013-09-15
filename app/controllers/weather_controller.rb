require 'date'
require 'open-uri'
require 'json'
class WeatherController < ApplicationController
  include ::WeatherUtil
  def index
    @errors = Array.new
    if params.has_key?(:search)
      if !(params[:search].nil?) or !(params[:search].empty?)
        regex = /\A[0-9]*\Z/
        #Check if param is a number, if so, geolocate based on post code
        #if params[:search].match regex
          zip = params[:search]
          geores = Geocoding.gets(params[:search])

          if(geores["status"] == "OK")
            addr_components = geores["results"][0]["address_components"]
            addr_components.each do |val|
              if val["types"].include? "locality"
                @city = val["long_name"]
              end
              if val["types"].include? "administrative_area_level_1"
                @state = val["long_name"]
              end
              if val["types"].include? "country"
                @country = val["long_name"]
              end
            end
          end
          
          
          begin
            @weather = get_weather @city, @state, @country
          rescue OpenUri::HTTPError => error
            @errors << error
          end
          
      end
    else
      #geolocate based on ip
      usr_ip = request.remote_ip
      mock_ip = '12.34.120.0'
      json = geocode_ip(mock_ip)
      if(json["statusCode"] == "OK")

        @city = json["cityName"].titlecase
        @state = json["regionName"].titlecase
        @country = json["countryName"].titlecase
        @weather = get_weather @city, @state, @country
      else
        @errors << "Could not locate you. Search to find weather"
      end
      logger.info json

    end
    date = Time.new
    @days = Array.new
    i = 0 
    wday = date.wday
    while i < 7 
      @days[i] = Date::DAYNAMES[wday]
      if wday == 6 then
        wday = 0
        i = i + 1
      else
        wday = wday + 1
        i = i + 1
      end
    end
  end
end
