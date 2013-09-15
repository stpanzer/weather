require 'forecast_io'
require 'date'
require 'open-uri'
require 'json'

class WeatherAjaxController < ApplicationController
  include ::WeatherUtil
  def get
    if params.has_key?(:name) and params.has_key?(:province) and params.has_key?(:country)
      #Check if city exists, hasn't been updated in the last ten minutes
      city = get_weather(params[:name], params[:province], params[:country])
      render json: city
    end
  end
end
