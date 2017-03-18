require 'prawn'
require "prawn/table"
# Ticket Model to access all the tickets
#
#   belongs_to state
#   belongs_to customer
#   belongs_to agent
# @attr [Integer] id
# @attr [String] name
# @attr [String] description
# @attr [Integer] state_id
# @attr [Integer] customer_id
# @attr [Integer] agent_id

class Ticket < ApplicationRecord
  belongs_to :state, optional: true
  belongs_to :customer, class_name: Customer
  belongs_to :agent, class_name: Agent, optional: true

  scope :customer_tickets, ->  (customer_id){where(customer_id: customer_id)}
  scope :state_tickets, ->  (state_name){includes(:state).where(states: {name: state_name})}
  scope :last_month_closed_tickets, ->  {includes(:state).where(states: {name: 'close'}).where("tickets.updated_at > ?", Date.today.prev_month)}

  delegate :name, :name, to: :customer, prefix: true, allow_nil: true
  delegate :name, :name, to: :agent, prefix: true, allow_nil: true
  delegate :name, :name, to: :state, prefix: true, allow_nil: true

  after_create :new_state!

  # Override as_json response structure with options
  #
  # @return [Hash]
  def as_json
    options={
      only: [:id, :name, :description],
      include: {
        customer: {only: [:name]},
        state: {only: [:name]},
        agent: {only: [:name]}
      }
    }
    super(options)
  end

  # Creates Monthly Report PDF File
  #
  # @param file_name [String]
  def self.generate_monthly_report(file_name)
    tickets = Ticket.last_month_closed_tickets
    Prawn::Document.generate(file_name, margin: 20, top_margin: 170, page_size: 'A4', page_layout: :portrait) do
      font_size(25) { text "Monthly Report", align: :center }
      move_down 10
      font 'Times-Roman'
      text "The Chairman,"
      data = [["Name", "Description", "Customer Name", "Agernt Name"]]
      tickets.each do |ticket|
        data << [ticket.name, ticket.description, ticket.customer_name, ticket.agent_name]
      end
      table(data, cell_style: { border_width: 1 })
    end
  end

  if ActiveRecord::Base.connection.data_source_exists? 'states'
    State.all.each do |state|
      define_method "#{state.name}_state!" do
        self.update_attributes(state_id: state.id)
      end
    end
  end

end
