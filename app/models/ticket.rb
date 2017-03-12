class Ticket < ApplicationRecord
  belongs_to :state
  belongs_to :customer, class_name: Customer
  belongs_to :agent, class_name: Agent

  scope :customer_tickets, ->  (customer_id){where(customer_id: customer_id)}
  scope :state_tickets, ->  (state_name){includes(:state).where(states: {name: state_name})}

  delegate :name, :name, to: :customer, prefix: true
  delegate :name, :name, to: :agent, prefix: true
  delegate :name, :name, to: :state, prefix: true

  def as_json
    options={
      only: [:id, :name, :description],
      include: {
        customer: {only: [:name]},
        state: {only: [:name]},
        agent: {only: [:name]},
      }
    }
    super(options)
  end

  ['new', 'inprogress', 'delete', 'close'].each do |state_name|
    define_method "#{state_name}_state!" do
      state = State.find_by(name: state_name)
      self.update_attributes(state_id: state.id)
    end
  end

end
