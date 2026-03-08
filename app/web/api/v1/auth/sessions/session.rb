# frozen_string_literal: true

module Api
  module V1
    module Auth
      module Sessions
        class Session
          attr_reader :user

          def initialize(user:)
            @user = user
          end

          delegate :email, to: :user

          def id
            'current'
          end

          delegate :id, to: :user, prefix: :user
        end
      end
    end
  end
end
