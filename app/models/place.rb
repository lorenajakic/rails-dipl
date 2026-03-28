class Place < ApplicationRecord
  CATEGORY_COLORS = {
    'restaurant' => '#f97316',
    'museum' => '#3b82f6',
    'park' => '#22c55e',
    'landmark' => '#a855f7',
    'shopping' => '#ec4899',
    'entertainment' => '#ef4444',
    'other' => '#6b7280'
  }.freeze

  enum :category, {
    restaurant: 0, museum: 1, park: 2, landmark: 3,
    shopping: 4, entertainment: 5, other: 6
  }

  belongs_to :trip
  belongs_to :added_by, class_name: 'User', inverse_of: :places

  has_many :place_comments, dependent: :destroy

  validates :name, presence: true
  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :category, presence: true

  after_create_commit :broadcast_append_to_places_list
  after_destroy_commit :broadcast_remove_from_places_list

  private

  def broadcast_append_to_places_list
    broadcast_append_to [trip, :places], target: 'places_list', partial: 'places/place', locals: { place: self }
  end

  def broadcast_remove_from_places_list
    return if trip_id.blank?

    broadcast_remove_to [Trip.find(trip_id), :places], target: self
  end
end
