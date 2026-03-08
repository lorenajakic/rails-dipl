# frozen_string_literal: true

module Api
  module V1
    module Books
      class Form < Book
        validates :number_of_copies, numericality: { greater_than: 1 }
        validates :title, length: { minimum: 3 }
      end
    end
  end
end
