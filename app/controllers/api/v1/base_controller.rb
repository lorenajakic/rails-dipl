# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      include Pundit::Authorization
      include InfinumJsonApiSetup::JsonApi::ErrorHandling
      include InfinumJsonApiSetup::JsonApi::ContentNegotiation
      include InfinumJsonApiSetup::JsonApi::RequestParsing
      include Api::V1::Concerns::Authentication

      rescue_from ActiveRecord::RecordInvalid do |exception|
        render_error(
          InfinumJsonApiSetup::Error::UnprocessableEntity.new(
            message: exception.record.errors.full_messages.join(', ')
          )
        )
      end

      self.responder = InfinumJsonApiSetup::JsonApi::Responder
      respond_to :json_api
    end
  end
end
