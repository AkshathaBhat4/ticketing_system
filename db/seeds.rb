# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Default User Details
user_types = [
  {name: 'admin'},
  {name: 'agent'},
  {name: 'customer'}
]
user_types.each do |user_type|
  UserType.where(user_type).first_or_create
end

admin = UserType.find_by(name: 'admin')
agent = UserType.find_by(name: 'agent')
customer = UserType.find_by(name: 'customer')
users = [
  {email: 'admin@gmail.com', name: 'Admin', password: 'admin@123456', password_confirmation: 'admin@123456', user_type_id: admin.id},
  {email: 'agent@gmail.com', name: 'Agent', password: 'agent@123456', password_confirmation: 'agent@123456', user_type_id: agent.id},
  {email: 'customer@gmail.com', name: 'Customer', password: 'customer@123456', password_confirmation: 'customer@123456', user_type_id: customer.id}
]
users.each do |user|
  User.where(email: user[:email]).first_or_create.update(user)
end

# Default Ticket Details

all_states = ['new', 'inprogress', 'close', 'delete']
all_states.each do |state|
  State.where(name: state).first_or_create
end
customer = Customer.first
State.all.each do |state|
  state_id = state.id
  tickets = {
    customer_id: customer.id,
    name: "Test Ticket #{state_id}",
    description: "Test Ticket #{state_id} Description",
    state_id: state_id
  }
  Ticket.where(tickets).first_or_create
end
