# frozen_string_literal: true

module Api
  module V1
    module Books
      module Sort
        class RatingUpdatedAt < Jsonapi::QueryBuilder::BaseSort
          def results
            collection.joins(:ratings).order('ratings.updated_at': direction)
          end
        end
      end
    end
  end
end
