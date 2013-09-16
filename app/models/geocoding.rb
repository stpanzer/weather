class Geocoding
  include HTTParty

  base_uri "http://maps.googleapis.com/maps/api/geocode/json?"

  def self.gets(zip)
    options = {query:{ address: zip, sensor: :false }}
    get('', options)
  end

end
