# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user_types = [
  {name: 'admin'},
  {name: 'agent'},
  {name: 'customer'}
]
user_types.each do |user_type|
  UserType.where(user_type).first_or_create
end

admin_user = UserType.find_by(name: 'admin')
users = [
  {email: 'admin@gmail.com', name: 'Admin', password: 'admin@123456', password_confirmation: 'admin@123456', user_type_id: admin_user.id}
]
User.destroy_all
User.create!(users)
