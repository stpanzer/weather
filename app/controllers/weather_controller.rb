require 'date'

class WeatherController < ApplicationController
  def index
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
