# frozen_string_literal: true

module Api
  module V1
    module Books
      class Serializer < Base::Serializer
        attribute :title
        attribute :number_of_copies
        attribute :created_at
        attribute :updated_at

        belongs_to :author
        has_many :genres
      end
    end
  end
end
