require 'rails_helper'

# So specs will run and not throw scary errors before LinksController is implemented
begin
  LinksController
rescue
  LinksController = nil
end

RSpec.describe LinksController, :type => :controller do
  let(:jack) { User.create!(username: 'jack_bruce', password: 'abcdef') }

  describe "GET #new" do
    context "when logged in" do

      before do
        allow(controller).to receive(:current_user) { jack }
      end

      it "renders the new links page" do
        get :new, post: {}
        expect(response).to render_template("new")
      end
    end

    context "when logged out" do
      before do
        allow(controller).to receive(:current_user) { nil }
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
        allow(controller).to receive(:current_user) { nil }
      end

      it "redirects to the login page" do
        get :index, post: {}
        expect(response).to redirect_to(new_session_url)
      end
    end
  end


  describe "PATCH #update" do
    context "when logged in as a different user" do
      create_jill_with_link

      before do
        allow(controller).to receive(:current_user) { jack }
      end

      it "should not allow users to update another users posts" do
        begin
          post :update, id: jill_link, link: {title: "Jack Hax"}
        rescue ActiveRecord::RecordNotFound
        end

        expect(jill_link.title).to eq("Jill Link")
      end
    end
  end

  describe "POST #create" do
    let(:jack_bruce) { User.create!(username: "jack_bruce", password: "abcdef") }

    before do
      allow(controller).to receive(:current_user) { jack_bruce }
    end

    context "with invalid params" do
      it "validates the presence of title and body" do
        post :create, link: {title: "this is an invalid link"}
        expect(response).to render_template("new")
        expect(flash[:errors]).to be_present
      end
    end

    context "with valid params" do
      it "redirects to the post show page" do
        post :create, link: {title: "teehee", url: "cats.com"}
        expect(response).to redirect_to(link_url(Link.last))
      end
    end
  end
end
