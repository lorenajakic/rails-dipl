# frozen_string_literal: true

module Api
  module V1
    module Books
      module Filter
        class GenreAny < Jsonapi::QueryBuilder::BaseFilter
          def results
            collection.joins(:genres)
                      .where(genres: { id: query })
                      .distinct
          end
        end
      end
    end
  end
end
