# frozen_string_literal: true

module Api
  module V1
    module Books
      class Query < Jsonapi::QueryBuilder::BaseQuery
        paginator Jsonapi::QueryBuilder::Paginator::Pagy

        sorts_by :title
        sorts_by :created_at
        sorts_by :updated_at
        sorts_by :rating_updated_at, Sort::RatingUpdatedAt

        filters_by :title
        filters_by :author_id
        filters_by :title_or_author, Filter::TitleOrAuthor
        filters_by :genre_any, Filter::GenreAny
        filters_by :genre_all, Filter::GenreAll
        filters_by :rating, Filter::Rating
      end
    end
  end
end
