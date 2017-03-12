class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :user_type
  scope :non_admin_users, -> { includes(:user_type).where.not(user_types: {name: 'admin'})}

  delegate :name, :name, to: :user_type, prefix: true

  after_save :update_user_type

  def  update_user_type
    if user_type.blank?
      customer = UserType.find_by(name: 'customer')
      self.update_column(:user_type_id, customer.id) 
    end
  end
end
