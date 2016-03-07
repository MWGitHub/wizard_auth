require 'rails_helper'

feature "Sign up" do
  before :each do
    visit "/wizards/new"
  end

  it "has a wizard sign up page" do
    expect(page).to have_content "Sign Up"
  end

  it "takes a username and password" do
    expect(page).to have_content "Username"
    expect(page).to have_content "Password"
  end

  it "logs the wizard in and redirects them to courses index on success" do
    sign_up_as_hermione_granger
    # add wizard name to application.html.erb layout
    expect(page).to have_content 'hermione_granger'
    expect(current_path).to eq("/courses")
  end
end

feature "Sign out" do
  it "has a sign out button" do
    sign_up_as_hermione_granger
    expect(page).to have_button 'Sign Out'
  end

  it "after logout, a wizard is not allowed access to courses index and is redirected to login" do
    sign_up_as_hermione_granger

    click_button 'Sign Out'
    visit '/courses'

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
    fill_in "Username", with: 'hermione_granger'
    fill_in "Password", with: 'hello'
    click_button "Sign In"

    # return to sign-in page
    expect(page).to have_content "Sign In"
    expect(page).to have_content "Username"
  end

  it "takes a wizard to courses index on success" do
    Wizard.create!(username: 'harry_potter', password: 'abcdef')
    sign_in('harry_potter')

    expect(page).to have_content "harry_potter"
    expect(current_path).to eq("/courses")
  end
end
