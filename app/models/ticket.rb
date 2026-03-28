class Ticket < ApplicationRecord
  MAX_FILE_SIZE = 20.megabytes
  ALLOWED_CONTENT_TYPES = [
    "application/pdf",
    "image/jpeg",
    "image/png",
    "image/webp"
  ].freeze

  enum :category, { flight: 0, accommodation: 1, activity: 2, transport: 3, other: 4 }

  belongs_to :trip
  belongs_to :uploaded_by, class_name: "User", inverse_of: :tickets

  has_one_attached :file

  validates :title, presence: true
  validates :category, presence: true
  validate :file_must_exist
  validate :acceptable_file, if: -> { file.attached? }

  private

  def file_must_exist
    errors.add(:file, :blank) unless file.attached?
  end

  def acceptable_file
    unless ALLOWED_CONTENT_TYPES.include?(file.content_type)
      errors.add(:file, :invalid_type)
    end

    return unless file.byte_size > MAX_FILE_SIZE

    errors.add(:file, :too_large)
  end
end
