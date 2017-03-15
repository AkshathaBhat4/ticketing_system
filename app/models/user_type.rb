# Specifies User Type
#
#   has_many users
# @attr [Integer] id
# @attr [String] name admin / agent / cuctomer
class UserType < ApplicationRecord
  has_many :users
end
