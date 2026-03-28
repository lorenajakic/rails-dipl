module Trips
  class InvitationSender
    def initialize(trip:, email:, invited_by:)
      @trip = trip
      @email = email.downcase.strip
      @invited_by = invited_by
    end

    def call
      invitee = User.find_by(email: email)
      return { error: I18n.t("invitations.errors.user_not_found") } unless invitee
      return { error: I18n.t("invitations.errors.already_participant") } if trip.participants.include?(invitee)
      return { error: I18n.t("invitations.errors.already_invited") } if trip.trip_invitations.pending.exists?(email: email)

      invitation = trip.trip_invitations.create!(email: email, invited_by: invited_by)

      { success: true, invitation: invitation }
    end

    private

    attr_reader :trip, :email, :invited_by
  end
end
