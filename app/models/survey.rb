class Survey < ActiveRecord::Base
  belongs_to :student
  attr_accessible :survey_type, :score
end
