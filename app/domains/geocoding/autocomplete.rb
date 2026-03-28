module Geocoding
  class Autocomplete
    PHOTON_URL = 'https://photon.komoot.io/api'

    def initialize(query:, limit: 5, lat: nil, lon: nil)
      @query = query
      @limit = limit
      @lat = lat.present? ? lat.to_f : nil
      @lon = lon.present? ? lon.to_f : nil
    end

    def call
      return [] if query.blank? || query.length < 2

      fetch_limit = [[limit * 3, 20].max, 50].min
      params = { q: query, limit: fetch_limit }
      params[:lat] = lat if lat.present? && lat.abs <= 90
      params[:lon] = lon if lon.present? && lon.abs <= 180

      response = HTTP.get(PHOTON_URL, params: params)
      return [] unless response.status.success?

      results = parse_features(response.parse)
      results = sort_by_proximity(results) if bias_coordinates?
      results.first(limit)
    end

    private

    attr_reader :query, :limit, :lat, :lon

    def bias_coordinates?
      lat.present? && lon.present? && lat.abs <= 90 && lon.abs <= 180
    end

    def sort_by_proximity(results)
      ref_lat = lat
      ref_lon = lon
      results.sort_by do |r|
        plat = r[:latitude].to_f
        plon = r[:longitude].to_f
        dlat = plat - ref_lat
        dlng = plon - ref_lon
        (dlat * dlat) + (dlng * dlng)
      end
    end

    def parse_features(data)
      (data['features'] || []).filter_map do |feature|
        props = feature['properties'] || {}
        coords = feature.dig('geometry', 'coordinates') || []
        plat = coords[1]
        plon = coords[0]
        next if plat.blank? || plon.blank?

        {
          name: props['name'],
          address: build_address(props),
          latitude: plat,
          longitude: plon,
          city: props['city'],
          country: props['country']
        }
      end
    end

    def build_address(props)
      [props['street'], props['city'], props['state'], props['country']]
        .compact.join(', ')
    end
  end
end
