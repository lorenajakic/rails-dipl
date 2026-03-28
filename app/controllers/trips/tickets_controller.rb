module Trips
  class TicketsController < BaseController
    before_action :set_ticket, only: [ :show, :edit, :update, :destroy ]

    def index
      scope = trip.tickets.includes(:uploaded_by, file_attachment: :blob).order(created_at: :desc)
      cat = params[:category].to_s
      @tickets = Ticket.categories.key?(cat) ? scope.where(category: cat) : scope
      @tickets_category_filter = Ticket.categories.key?(cat) ? cat : nil
    end

    def new
      @ticket = trip.tickets.build
      authorize @ticket
    end

    def create
      @ticket = trip.tickets.build(ticket_row_attributes)
      @ticket.uploaded_by = current_user
      @ticket.file.attach(ticket_file_param) if ticket_file_param.present?

      authorize @ticket

      if @ticket.save
        redirect_to trip_tickets_path(trip), notice: t("tickets.created")
      else
        render :new, status: :unprocessable_entity
      end
    end

    def show
      authorize @ticket
    end

    def edit
      authorize @ticket
    end

    def update
      authorize @ticket
      @ticket.assign_attributes(ticket_row_attributes)
      @ticket.file.attach(ticket_file_param) if ticket_file_param.present?

      if @ticket.save
        redirect_to trip_tickets_path(trip), notice: t("tickets.updated")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @ticket
      @ticket.destroy!
      redirect_to trip_tickets_path(trip), notice: t("tickets.deleted")
    end

    private

    def set_ticket
      @ticket = trip.tickets.find(params[:id])
    end

    def ticket_row_attributes
      p = params.require(:ticket).permit(:title, :category, :date, :details, :cost_currency, :cost)
      h = {
        title: p[:title],
        category: p[:category],
        date: p[:date].presence,
        details: p[:details].presence,
        cost_currency: p[:cost_currency].presence || "EUR"
      }
      h[:cost_cents] = if p[:cost].present?
        (BigDecimal(p[:cost].to_s) * 100).round
      end
      h
    end

    def ticket_file_param
      params.dig(:ticket, :file)
    end
  end
end
