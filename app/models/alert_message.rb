class AlertMessage < ActiveRecord::Base

  validates_presence_of :message
  validates_inclusion_of :active, in: [true, false]

end