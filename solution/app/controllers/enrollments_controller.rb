class EnrollmentsController < ApplicationController
  before_action :redirect_unless_student

  def create
    enrollment = Enrollment.new(comment_params)
    enrollment.student_id = current_wizard.id

    enrollment.save
    flash[:errors] = enrollment.errors.full_messages
    course_id = params[:enrollment][:course_id]
    redirect_to course_url(course_id)
  end

  def destroy
    enrollment = Enrollment.find(params[:id])
    enrollment.destroy
    redirect_to course_url(enrollment.course_id)
  end

  private
  def comment_params
    params.require(:enrollment).permit(:course_id)
  end

  def redirect_unless_student
    redirect_to courses_url if current_wizard.instructor
  end
end
