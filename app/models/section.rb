class Section < ActiveRecord::Base
  attr_accessible :location, :enrollment, :capacity, :waitlist_enrollment, :waitlist_capacity, :class_number, :description, :synopsis, :parsedUnits, :name, :list_name, :room, :units, :career, :grading, :campus
#  validates :suffix, :section_type, :location, :enrollment, :capacity, :waitlist_enrollment, :waitlist_capacity, :class_number, presence:true

  has_and_belongs_to_many :course_attributes
  has_and_belongs_to_many :instructors
  belongs_to :course
  belongs_to :time_slot
end
