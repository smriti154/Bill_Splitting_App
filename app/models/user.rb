class User < ActiveRecord::Base
	has_many :bills
    has_many :bills, :through => :payments
    validates :name, presence: true
    validates_uniqueness_of :name
end
