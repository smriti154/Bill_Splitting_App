class Payment < ActiveRecord::Base
	# attr_accessible :user_id, :bill_id
      belongs_to :user
      belongs_to :bill
      validates :paid_amount, presence: true
      validates_uniqueness_of :user_id, :scope => [:bill_id]
end
