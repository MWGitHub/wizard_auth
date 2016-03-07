# == Schema Information
#
# Table name: courses
#
#  id             :integer          not null, primary key
#  title          :string(255)      not null, unique
#  instructor_id  :boolean          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Course < ActiveRecord::Base
  validates :title, :description, :instructor_id, presence: true

  belongs_to :instructor,
    class_name: "Wizard",
    foreign_key: :instructor_id,
    primary_key: :id

  has_many :enrollments,
    class_name: "Enrollment",
    foreign_key: :course_id,
    primary_key: :id
end
