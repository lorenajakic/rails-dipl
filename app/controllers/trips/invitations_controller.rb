module Trips
  class InvitationsController < BaseController
    def create
      result = ::Trips::InvitationSender.new(
        trip: trip,
        email: params[:email],
        invited_by: current_user
      ).call

      if result[:success]
        redirect_to trip_path(trip), notice: t("invitations.sent")
      else
        redirect_to trip_path(trip), alert: result[:error]
      end
    end
  end
end
