class TripPolicy < ApplicationPolicy
  def show?
    participant?
  end

  def create?
    true
  end

  def update?
    creator? && editable?
  end

  def destroy?
    creator?
  end

  def invite?
    participant?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:trip_participants).where(trip_participants: { user_id: user.id })
    end
  end

  private

  def participant?
    record.participants.include?(user)
  end

  def creator?
    record.creator == user
  end

  def editable?
    record.draft? || record.planning?
  end
end
