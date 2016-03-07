# == Schema Information
#
# Table name: enrollments
#
#  id         :integer          not null, primary key
#  student_id :integer          not null
#  course_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Enrollment < ActiveRecord::Base
  validates :student_id, :course_id, presence: true

  belongs_to :student,
    class_name: "Wizard",
    foreign_key: :student_id,
    primary_key: :id

  belongs_to :course,
    class_name: "Course",
    foreign_key: :course_id,
    primary_key: :id
end
