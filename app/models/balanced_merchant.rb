class BalancedMerchant < ActiveRecord::Base
  belongs_to :user
  attr_accessible :account, :valid_from, :valid_to
end
