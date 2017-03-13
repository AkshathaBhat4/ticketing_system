class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :user_type
  has_many :customer_tickets, foreign_key: 'customer_id', class_name: Ticket
  has_many :agent_tickets, foreign_key: 'agent_id', class_name: Ticket
  scope :non_admin_users, -> { includes(:user_type).where.not(user_types: {name: 'admin'})}
  scope :admin_users, -> { includes(:user_type).where(user_types: {name: 'admin'})}

  delegate :name, :name, to: :user_type, prefix: true

  after_save :update_user_type

  def as_json
    options={
      only: [:id, :email, :name, :user_type_id],
      include: {
        user_type: {only: [:name]}
      }
    }
    super(options)
  end

  def  update_user_type
    if user_type.blank?
      customer = UserType.find_by(name: 'customer')
      self.update_column(:user_type_id, customer.id)
    end
  end

  def admin_tabs
    {
      'users': 'Manage Users',
      'tickets': 'Manage Tickets'
    }
  end

  def agent_tabs
    {
      'tickets': 'Manage Tickets'
    }
  end

  def customer_tabs
    {
      'tickets': 'Manage Tickets',
      'new_ticket': 'Raise Ticket'
    }
  end

  def user_tabs
    self.send("#{user_type_name}_tabs")
  end

  def allowed_ticket_state
    self.send("#{user_type_name}_state")
  end

  if ActiveRecord::Base.connection.data_source_exists? 'user_types'
    UserType.all.each do |ut|
      define_method "is_#{ut.name}?" do
        user_type_name == ut.name
      end

      define_method "#{ut.name}_state" do
        states = {}
        State.send("#{ut.name}_state").each do |state|
          states[state.name] = state.name.capitalize
        end
        states
      end
    end
  end
end
