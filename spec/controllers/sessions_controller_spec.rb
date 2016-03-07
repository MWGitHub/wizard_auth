require 'rails_helper'

# So specs will run and not throw scary errors before SessionsController is implemented
begin
  SessionsController
rescue
  SessionsController = nil
end

RSpec.describe SessionsController, :type => :controller do
  let!(:wizard) { Wizard.create({username: "harry_potter", password: "abcdef"}) }

  context "with invalid credentials" do
    it "returns to sign in with an non-existent wizard" do
      post :create, wizard: {username: "mcgonagall", password: "abcdef"}
      expect(response).to render_template("new")
      expect(flash[:errors]).to be_present
    end

    it "returns to sign in on bad password" do
      post :create, wizard: {username: "harry_potter", password: "notmypassword"}
      expect(response).to render_template("new")
      expect(flash[:errors]).to be_present
    end
  end

  context "with valid credentials" do
    it "redirects wizard to posts index on success" do
      post :create, wizard: {username: "harry_potter", password: "abcdef"}
      expect(response).to redirect_to(courses_url)
    end
  end
end
