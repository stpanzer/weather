class AddAreaToCityWeather < ActiveRecord::Migration
  def change
    add_column :city_weathers, :area, :string
  end
end
