class Friend < ActiveRecord::Base
  belongs_to :user
  attr_accessible :city, :first_name, :last_name, :state, :street_address, :zipcode

  validates :first_name, :presence => true
end
