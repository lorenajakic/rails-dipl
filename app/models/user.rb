class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  has_many :trip_participants, dependent: :destroy
  has_many :trips, through: :trip_participants
  has_many :created_trips, class_name: "Trip", foreign_key: :creator_id,
                           inverse_of: :creator, dependent: :destroy
  has_many :places, foreign_key: :added_by_id, inverse_of: :added_by, dependent: :nullify
  has_many :place_comments, dependent: :destroy
  has_many :sent_invitations, class_name: "TripInvitation", foreign_key: :invited_by_id,
                              inverse_of: :invited_by, dependent: :destroy
  has_many :tickets, foreign_key: :uploaded_by_id, inverse_of: :uploaded_by, dependent: :destroy

  validates :name, presence: true
end
