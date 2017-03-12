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
end
