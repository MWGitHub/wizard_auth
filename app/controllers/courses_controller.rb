class CoursesController < ApplicationController
  before_filter :require_signed_in!
  before_filter :require_instructor!, except: [:index, :show]

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.instructor_id = current_wizard.id
    if @course.save
      redirect_to course_url(@course)
    else
      flash.now[:errors] = @course.errors.full_messages
      render :new
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(course_params)
      redirect_to course_url(@course)
    else
      flash.now[:errors] = @course.errors.full_messages
      render :edit
    end
  end

  def destroy
    course = Course.find(params[:id])
    course.destroy
    redirect_to courses_url
  end

  private
  def course_params
    params.require(:course).permit(:title, :description)
  end

  def require_instructor!
    redirect_to courses_url unless current_wizard.instructor
  end
end
