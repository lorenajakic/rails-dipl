class Trip < ApplicationRecord
  enum :status, { draft: 0, planning: 1, finalized: 2, completed: 3 }

  belongs_to :creator, class_name: "User", inverse_of: :created_trips

  has_one_attached :cover_image

  has_many :trip_participants, dependent: :destroy
  has_many :participants, through: :trip_participants, source: :user
  has_many :trip_invitations, dependent: :destroy
  has_many :places, dependent: :destroy
  has_many :tickets, dependent: :destroy

  validates :title, presence: true
  validates :destination, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  scope :ordered_by_start_date, -> { order(start_date: :asc) }

  def duration_days
    (end_date - start_date).to_i + 1
  end

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    errors.add(:end_date, "must be after start date") if end_date < start_date
  end
end
