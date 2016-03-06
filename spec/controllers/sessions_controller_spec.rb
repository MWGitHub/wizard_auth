require 'rails_helper'

# So specs will run and not throw scary errors before SessionsController is implemented
begin
  SessionsController
rescue
  SessionsController = nil
end

RSpec.describe SessionsController, :type => :controller do
  let!(:user) { User.create({username: "jack_bruce", password: "abcdef"}) }

  context "with invalid credentials" do
    it "returns to sign in with an non-existent user" do
      post :create, user: {username: "jill_bruce", password: "abcdef"}
      expect(response).to render_template("new")
      expect(flash[:errors]).to be_present
    end

    it "returns to sign in on bad password" do
      post :create, user: {username: "jack_bruce", password: "notmypassword"}
      expect(response).to render_template("new")
      expect(flash[:errors]).to be_present
    end
  end

  context "with valid credentials" do
    it "redirects user to posts index on success" do
      post :create, user: {username: "jack_bruce", password: "abcdef"}
      expect(response).to redirect_to(links_url)
    end
  end
end
