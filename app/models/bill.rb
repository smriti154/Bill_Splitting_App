class Bill < ActiveRecord::Base
	# attr_accessible :event_name, :location
	EVENTNAMES = ['Lunch', 'Dinner', 'Snacks']
      has_many :users
      has_many :users, :through => :payments
    validates :location, :total_amount, presence: true
end
