require 'date'
require 'open-uri'
require 'json'
class WeatherController < ApplicationController
  include ::WeatherUtil
  def index
    @errors = Array.new
    if params.has_key?(:search)
      if !(params[:search].nil?) or !(params[:search].empty?)
        zip = params[:search]
        geores = Geocoding.gets(params[:search])
        if(geores["status"] == "OK")
          addr_components = geores["results"][0]["address_components"]
          addr_components.each do |val|
            if val["types"].include? "locality"
              @city = val["long_name"]
            end
            if val["types"].include? "administrative_area_level_2"
              @area = val["long_name"]
            end
            if val["types"].include? "administrative_area_level_1"
              @state = val["long_name"]
            end
            if val["types"].include? "country"
              @country = val["long_name"]
            end
          end
          begin
            hash = {cityName:@city, area: @area, province: @state, country: @country}
            @weather = get_weather hash
          rescue OpenURI::HTTPError => error
            @errors << error
          end
          if @weather.nil?
            #openweathermap doesn't like very specific locations, so lets try just city/country
            hash = {cityName:@city, country: @country}
            begin
              @weather = get_weather hash
            rescue OpenURI::HTTPError => error
              @errors << error
            end
            if @weather.nil?
              @errors << "I had trouble finding weather for you. Try a different search."
            end
          end
        else
            @errors << "Search returned no results"
        end               
     end
    else
      #geolocate based on ip
      usr_ip = request.remote_ip
      mock_ip = '12.34.10.80'
      json = geocode_ip(mock_ip)
      if(json["statusCode"] == "OK")

        @city = json["cityName"].titlecase
        @state = json["regionName"].titlecase
        @country = json["countryName"].titlecase
        @weather = get_weather ({cityName: @city, province: @state, country: @country})
      else
        @errors << "Could not locate you. Search to find weather"
      end

    end
    #set up background image based on today's weather, set attribution
    if !(@weather.nil?) then
      @background = get_bg_attribution @weather['weather']['list'][0]['weather'][0]["main"].downcase
    end
    #set up days and dates for the view
    date = Time.new
    @dates = Array.new
    i = 0 
    wday = date.wday
    while i < 7 
      @dates[i] = date + ((60 * 60 * 24) * i)
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
