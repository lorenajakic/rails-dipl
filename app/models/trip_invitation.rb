class TripInvitation < ApplicationRecord
  belongs_to :trip
  belongs_to :invited_by, class_name: "User", inverse_of: :sent_invitations

  validates :email, presence: true
  validates :email, uniqueness: { scope: :trip_id }
  validates :token, presence: true, uniqueness: true

  before_validation :generate_token, on: :create

  scope :pending, -> { where(accepted_at: nil) }

  def self.pending_for(user)
    return none unless user

    pending.where(email: user.email.to_s.downcase.strip)
  end

  def accepted?
    accepted_at.present?
  end

  private

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(32)
  end
end
