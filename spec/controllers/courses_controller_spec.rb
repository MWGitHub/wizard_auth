require 'rails_helper'

# So specs will run and not throw scary errors before CoursesController is implemented
begin
  CoursesController
rescue
  CoursesController = nil
end

RSpec.describe CoursesController, :type => :controller do
  let(:dumbledore) {
    Wizard.create!(
      username: 'dumbledore',
      password: 'password',
      instructor: true
    )
  }
  let(:harry) { Wizard.create!(username: 'harry_potter', password: 'abcdef') }

  describe "GET #new" do
    context "when logged in as a student" do
      before do
        allow(controller).to receive(:current_wizard) { harry }
      end

      it "redirects to the courses index page" do
        get :new, post: {}
        expect(response).to redirect_to(courses_url)
      end
    end

    context "when logged in as an instructor" do

      before do
        allow(controller).to receive(:current_wizard) { dumbledore }
      end

      it "renders the new course page" do
        get :new, post: {}
        expect(response).to render_template("new")
      end
    end

    context "when logged out" do
      before do
        allow(controller).to receive(:current_wizard) { nil }
      end

      it "redirects to the login page" do
        get :new, post: {}
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe "GET #index" do
    context "when logged out" do
      before do
        allow(controller).to receive(:current_wizard) { nil }
      end

      it "redirects to the login page" do
        get :index, post: {}
        expect(response).to redirect_to(new_session_url)
      end
    end
  end


  describe "PATCH #update" do
    context "when logged in as a student" do
      create_mcgonagall_with_course

      before do
        allow(controller).to receive(:current_wizard) { harry }
      end

      it "redirects to the courses index page" do
        post :update, id: mcgonagall_course, course: {}
        expect(response).to redirect_to(courses_url)
      end
    end

    context "when logged in as a different instructor" do
      create_mcgonagall_with_course

      before do
        allow(controller).to receive(:current_wizard) { dumbledore }
      end

      it "should not allow instructors to update another instructor's courses" do
        begin
          post :update, id: mcgonagall_course, course: {title: "Jack Hax"}
        rescue ActiveRecord::RecordNotFound
        end

        expect(mcgonagall_course.title).to eq("Transfiguration")
      end
    end
  end

  describe "POST #create" do
    before do
      allow(controller).to receive(:current_wizard) { dumbledore }
    end

    context "with invalid params" do
      it "validates the presence of title and body" do
        post :create, course: {title: "this is an invalid course"}
        expect(response).to render_template("new")
        expect(flash[:errors]).to be_present
      end
    end

    context "with valid params" do
      it "redirects to the post show page" do
        post :create, course: {title: "teehee", description: "learn magic"}
        expect(response).to redirect_to(course_url(Course.last))
      end
    end
  end
end
