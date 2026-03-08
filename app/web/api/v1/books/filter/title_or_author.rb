# frozen_string_literal: true

module Api
  module V1
    module Books
      module Filter
        class TitleOrAuthor < Jsonapi::QueryBuilder::BaseFilter
          def results
            collection.left_joins(:author)
                      .where('books.title ILIKE :query OR authors.first_name ILIKE :query', query: "%#{query}%")
          end
        end
      end
    end
  end
end
