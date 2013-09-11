require 'forecast_io'
require 'date'
require 'open-uri'
require 'json'

class WeatherAjaxController < ApplicationController
  include ::WeatherUtil
  def get
    if params.has_key?(:name) and params.has_key?(:province) and params.has_key?(:country)
      #Check if city exists, hasn't been updated in the last ten minutes
      if CityWeather.exists?(cityName: params[:name], province: params[:province], country: params[:country])
        city = CityWeather.find_by cityName: params[:name], province: params[:province], country: params[:country]
        t = DateTime.now
        diff = ((t - city.updated_at.to_datetime)*24*60)
        if diff < 10
          render json: city
        else
          begin
            json = get_weather params[:name], params[:province], params[:country]
          rescue OpenURI::HTTPError => error
            render json: { :error => "#{error}" }
          end
          city.weather = json
          city.save
          render json: city
        end
      else
        #City is new. create a db entry and fill in the data
        newCity = CityWeather.new cityName: params[:name], province: params[:province], country: params[:country]
        begin
          json = get_weather params[:name], params[:province], params[:country]
        rescue OpenURI::HTTPError => error
          render json: { :error => "#{error}" }
          return
        end
        newCity.weather = json
        newCity.save
        render json: newCity
      end
    end
  end
end
