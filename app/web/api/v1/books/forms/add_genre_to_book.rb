# frozen_string_literal: true

module Api
  module V1
    module Books
      module Forms
        class AddGenreToBook
          include ActiveModel::Model

          attr_accessor :book
          attr_accessor :genres

          validate :max_five_genres_per_book

          def initialize(book, genres)
            @book = book
            @genres = genres
          end

          def save
            return false if invalid?

            book.genres << genres
          end

          private

          def max_five_genres_per_book
            return if book.genres.count + genres.count <= 5

            errors.add(:genres, 'exceed the maximum of 5')
            book.errors.add(:genres, 'exceed the maximum of 5')
          end
        end
      end
    end
  end
end
