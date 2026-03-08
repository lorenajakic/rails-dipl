# frozen_string_literal: true

module Api
  module V1
    module Auth
      module Sessions
        class Form < ActiveType::Object
          extend Memoist

          attribute :email, :string
          attribute :password, :string

          validates :email, presence: true
          validates :password, presence: true

          validate :user_exists
          validate :user_has_valid_password, if: :user

          memoize def user
            User.find_for_authentication(email: email)
          end

          private

          def user_exists
            return if user

            errors.add(:email, 'User not found')
          end

          def user_has_valid_password
            return if user.valid_password?(password)

            errors.add(:password, 'Invalid password')
          end
        end
      end
    end
  end
end
