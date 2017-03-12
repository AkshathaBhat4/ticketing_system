class State < ApplicationRecord
  scope :admin_state, -> {where.not(name: ['new'])}
  scope :customer_state, -> {where(name: ['delete'])}
  scope :agent_state, -> {where.not(name: ['new', 'delete'])}
end
