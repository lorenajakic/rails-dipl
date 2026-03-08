# frozen_string_literal: true

module Api
  module V1
    module Books
      module Filter
        class Rating < Jsonapi::QueryBuilder::BaseFilter
          def results
            collection.joins(:ratings)
                      .where(ratings: { score: query.. })
                      .distinct
          end
        end
      end
    end
  end
end
