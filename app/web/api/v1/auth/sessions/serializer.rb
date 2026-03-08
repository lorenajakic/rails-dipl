# frozen_string_literal: true

module Api
  module V1
    module Auth
      module Sessions
        class Serializer < Base::Serializer
          set_type :session

          attribute :email

          has_one :user, serializer: Api::V1::Users::Serializer
        end
      end
    end
  end
end
