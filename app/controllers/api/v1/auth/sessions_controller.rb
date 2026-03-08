# frozen_string_literal: true

module Api
  module V1
    module Auth
      class SessionsController < BaseController
        def create
          form = Api::V1::Auth::Sessions::Form.new(session_params)

          if form.valid?
            sign_in('user', form.user)
            respond_with Api::V1::Auth::Sessions::Session.new(user: form.user)
          else
            respond_with form
          end
        end

        def session_params
          params.from_jsonapi
                .require(:session)
                .permit(:email, :password)
        end
      end
    end
  end
end
