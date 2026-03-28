class DashboardController < ApplicationController
  def index
    @trips = current_user.trips.ordered_by_start_date
                          .includes(participants: { avatar_attachment: :blob })
  end
end
