class TicketPolicy < ApplicationPolicy
  def show?
    participant?
  end

  def create?
    participant?
  end

  def update?
    destroy?
  end

  def destroy?
    participant? && (record.uploaded_by_id == user.id || record.trip.creator_id == user.id)
  end

  private

  def participant?
    record.trip.participants.include?(user)
  end
end
