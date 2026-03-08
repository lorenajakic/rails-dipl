# frozen_string_literal: true

module Api
  module V1
    module Users
      class Serializer < Base::Serializer
        attribute :email
        attribute :role
      end
    end
  end
end
