class TicketsController < ApplicationController
  def show
    if params[:id].present?
      ticket = Ticket.find_by(id: params[:id])
      render json: ticket.as_json
    else
      if current_user.is_customer?
        @tickets = Ticket.customer_tickets(current_user.id)
      else
        @tickets = Ticket.all
      end
      @tickets = @tickets.state_tickets(params['state']) if params['state'].present? && params['state'] != 'all'
      render json: @tickets.as_json
    end
  end

  def change_state
    ticket = Ticket.find_by(id: params[:id])
    name = params[:state]
    if current_user.allowed_ticket_state.has_key?(name)
      ticket.send("#{name}_state!")
      ticket.update_attributes(agent_id: current_user.id) if current_user.is_agent?
      ticket.reload
      render json: ticket.as_json
    else
      render json: {"#{name}": 'state not allowed'}, status: :unprocessable_entity
    end
  end

  def create
    @ticket = current_user.customer_tickets.new(ticket_params)

    if @ticket.save
      render json: @ticket.as_json
    else
      render json: @ticket.errors.to_json, status: :unprocessable_entity
    end
  end

  def generate_report
    file_name = "tmp/ticket_report_#{Date.today.strftime("%d_%m_%Y")}.pdf"
    Ticket.generate_monthly_report(file_name)
    send_file file_name
  end

  private

    def ticket_params
      params.require(:ticket).permit(:name, :description)
    end
end
