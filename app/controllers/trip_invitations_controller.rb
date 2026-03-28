class TripInvitationsController < ApplicationController
  before_action :set_invitation, only: [ :accept, :decline ]

  def index
    @pending_invitations = TripInvitation.pending_for(current_user)
      .includes(trip: :creator)
      .order(created_at: :desc)
  end

  def accept
    ActiveRecord::Base.transaction do
      invitation.trip.trip_participants.find_or_create_by!(user: current_user)
      invitation.update!(accepted_at: Time.current)
    end

    redirect_to trip_path(invitation.trip), notice: t("invitations.accepted")
  end

  def decline
    invitation.destroy!
    redirect_to invitations_path, notice: t("invitations.declined")
  end

  private

  attr_reader :invitation

  def set_invitation
    @invitation = TripInvitation.pending_for(current_user).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to invitations_path, alert: t("invitations.not_found")
  end
end
