require 'rails_helper'

feature "Sign up" do
  before :each do
    visit "/users/new"
  end

  it "has a user sign up page" do
    expect(page).to have_content "Sign Up"
  end

  it "takes a username and password" do
    expect(page).to have_content "Username"
    expect(page).to have_content "Password"
  end

  it "logs the user in and redirects them to links index on success" do
    sign_up_as_ginger_baker
    # add user name to application.html.erb layout
    expect(page).to have_content 'ginger_baker'
    expect(current_path).to eq("/links")
  end
end

feature "Sign out" do
  it "has a sign out button" do
    sign_up_as_ginger_baker
    expect(page).to have_button 'Sign Out'
  end

  it "after logout, a user is not allowed access to links index and is redirected to login" do
    sign_up_as_ginger_baker

    click_button 'Sign Out'
    visit '/links'

    # redirect to login page
    expect(page).to have_content 'Sign In'
    expect(page).to have_content "Username"
  end
end

feature "Sign in" do
  it "has a sign in page" do
    visit "/session/new"
    expect(page).to have_content "Sign In"
  end

  it "takes a username and password" do
    visit "/session/new"
    expect(page).to have_content "Username"
    expect(page).to have_content "Password"
  end

  it "returns to sign in on failure" do
    visit "/session/new"
    fill_in "Username", with: 'ginger_baker'
    fill_in "Password", with: 'hello'
    click_button "Sign In"

    # return to sign-in page
    expect(page).to have_content "Sign In"
    expect(page).to have_content "Username"
  end

  it "takes a user to links index on success" do
    User.create!(username: 'jack_bruce', password: 'abcdef')
    sign_in('jack_bruce')

    expect(page).to have_content "jack_bruce"
    expect(current_path).to eq("/links")
  end
end
