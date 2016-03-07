require 'rails_helper'

# So specs will run and not throw scary errors before WizardsController is implemented
begin
  WizardsController
rescue
  WizardsController = nil
end

RSpec.describe WizardsController, :type => :controller do

  describe "POST #create" do
    context "with invalid params" do
      it "validates the presence of the wizard's username and password" do
        post :create, wizard: {username: "harry_potter", password: ""}
        expect(response).to render_template("new")
        expect(flash[:errors]).to be_present
      end

      it "validates that the password is at least 6 characters long" do
        post :create, wizard: {username: "harry_potter", password: "short"}
        expect(response).to render_template("new")
        expect(flash[:errors]).to be_present
      end

      it "validates that a username must be unique" do
        post :create, wizard: {username: "harry_potter", password: "password"}
        post :create, wizard: {username: "harry_potter", password: "password"}
        expect(response).to render_template("new")
        expect(flash[:errors]).to be_present
      end

      it "does not permit setting instructor" do
        post :create, wizard: {
          username: "harry_potter",
          password: "password",
          instructor: true
        }
        wizard = Wizard.find_by(username: "harry_potter")
        expect(wizard.instructor).to be_falsey
      end
    end

    context "with valid params" do
      it "redirects wizard to courses index on success" do
        post :create, wizard: {username: "harry_potter", password: "password"}
        expect(response).to redirect_to(courses_url)
      end
    end
  end
end
