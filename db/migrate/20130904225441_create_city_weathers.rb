class CreateCityWeathers < ActiveRecord::Migration
  def change
    create_table :city_weathers do |t|
      t.string :cityName
      t.string :weather

      t.timestamps
    end
  end
end
