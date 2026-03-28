class PlaceComment < ApplicationRecord
  belongs_to :place
  belongs_to :user

  validates :body, presence: true
end
