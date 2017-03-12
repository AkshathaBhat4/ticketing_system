class Customer < User
  has_many :tickets
  default_scope -> {includes(:user_type).where(user_types: {name: 'customer'})}
end
