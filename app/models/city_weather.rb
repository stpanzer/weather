class CityWeather < ActiveRecord::Base
  serialize :weather, JSON
end
