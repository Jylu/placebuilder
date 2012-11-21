class BalancedCreditCard < ActiveRecord::Base
  attr_accessible :account, :invalid_at, :user, :valid_at
end
