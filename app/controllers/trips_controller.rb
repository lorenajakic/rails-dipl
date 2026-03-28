class TripsController < ApplicationController
  before_action :set_trip, only: [ :show, :edit, :update, :destroy ]

  def new
    @trip = Trip.new
    authorize trip
  end

  def create
    @trip = current_user.created_trips.build(trip_params)
    authorize trip

    if trip.save
      trip.trip_participants.create!(user: current_user)
      redirect_to trip, notice: t("trips.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    authorize trip
    load_places_for_show
    load_tickets_for_show
  end

  def edit
    authorize trip
  end

  def update
    authorize trip

    if trip.update(trip_params)
      redirect_to trip, notice: t("trips.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize trip
    trip.destroy!
    redirect_to root_path, notice: t("trips.deleted")
  end

  private

  attr_reader :trip

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(:title, :destination, :start_date, :end_date, :cover_image)
  end

  def load_places_for_show
    @places = trip.places.includes(:added_by, place_comments: :user).order(created_at: :asc)
  end

  def load_tickets_for_show
    scope = trip.tickets.includes(:uploaded_by, file_attachment: :blob).order(created_at: :desc)
    cat = params[:tickets_category].to_s
    @tickets = if cat.present? && Ticket.categories.key?(cat)
      scope.where(category: cat)
    else
      scope
    end
    @tickets_category_filter = cat.presence
  end
end
