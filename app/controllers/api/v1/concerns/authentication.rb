# frozen_string_literal: true

module Api
  module V1
    module Concerns
      module Authentication
        def authenticate_api_user!
          return if current_user.present?

          error = InfinumJsonApiSetup::Error::Unauthorized.new
          render json_api: error, status: error.http_status
        end

        def current_user
          @current_user ||= warden.authenticate(scope: :user)
        end
      end
    end
  end
end
