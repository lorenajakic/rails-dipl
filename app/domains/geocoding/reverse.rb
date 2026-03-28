module Geocoding
  class Reverse
    PHOTON_REVERSE_URL = 'https://photon.komoot.io/reverse'

    def initialize(lat:, lon:)
      @lat = lat.to_f
      @lon = lon.to_f
    end

    def call
      return nil unless lat.abs <= 90 && lon.abs <= 180

      response = HTTP.get(PHOTON_REVERSE_URL, params: { lat: lat, lon: lon })
      return nil unless response.status.success?

      data = response.parse
      feature = (data['features'] || []).first
      return nil unless feature

      props = feature['properties'] || {}
      coords = feature.dig('geometry', 'coordinates') || []
      plat = coords[1]
      plon = coords[0]
      return nil if plat.blank? || plon.blank?

      address = build_address(props)
      name = props['name'].presence || address.presence

      {
        name: name,
        address: address,
        latitude: plat,
        longitude: plon
      }
    end

    private

    attr_reader :lat, :lon

    def build_address(props)
      [props['street'], props['city'], props['state'], props['country']]
        .compact.join(', ')
    end
  end
end
