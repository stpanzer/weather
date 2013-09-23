class AlterWeatherType < ActiveRecord::Migration
  def up
    change_column :city_weathers, :weather, :text
  end
  def down
    change_column :city_weathers, :weather, :string
  end
end
