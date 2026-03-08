# frozen_string_literal: true

module Api
  module V1
    module Books
      module Filter
        class GenreAll < Jsonapi::QueryBuilder::BaseFilter
          def results
            collection.joins(:genres)
                      .where(genres: { id: query })
                      .group('books.id')
                      .having('COUNT(DISTINCT genres.id) = ?', query.size)
          end
        end
      end
    end
  end
end
