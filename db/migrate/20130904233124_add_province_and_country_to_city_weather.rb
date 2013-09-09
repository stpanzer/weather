class AddProvinceAndCountryToCityWeather < ActiveRecord::Migration
  def change
    add_column :city_weathers, :province, :string
    add_column :city_weathers, :country, :string
  end
end
