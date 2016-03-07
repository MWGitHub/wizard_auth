require 'rails_helper'

feature "Adding enrollments to courses" do
  before :each do
    create_dumbledore
    sign_in('dumbledore')
    make_course("Magic Course", "I teach magic")
    make_course("Science Course", "I teach science in a school bus")
    click_on 'Sign Out'

    sign_up_as_hermione_granger
    click_link 'Magic Course'
  end

  it "should not allow instructors from enrolling" do
    click_on 'Sign Out'
    sign_in('dumbledore')
    click_link 'Magic Course'

    expect(page).to_not have_button 'Enroll'
  end

  it "there is an enrollment button on the course show page" do
    expect(page).to have_button 'Enroll'
  end

  it "shows the course show page on submit" do
    click_button 'Enroll'
    expect(page).to have_content 'hermione_granger'
  end

  it "after enrolling; student is added to list" do
    click_button 'Enroll'
    click_on 'Sign Out'
    sign_in('dumbledore')
    click_link 'Magic Course'
    expect(page).to have_content 'hermione_granger'
  end
end

feature "Deleting comments" do
  before :each do
    create_dumbledore
    sign_in('dumbledore')
    make_course("Magic Course", "I teach magic")
    click_on 'Sign Out'

    sign_up_as_hermione_granger
    click_link 'Magic Course'
    click_button "Enroll"
  end

  it "displays a withdraw button next to each enrollment" do
    expect(page).to have_button 'Withdraw'
  end

  it "shows the course show page on click" do
    click_button 'Withdraw'
    expect(page).to have_content 'dumbledore'
  end

  it "removes the comment on click" do
    click_button 'Withdraw'
    click_on 'Sign Out'

    sign_in('dumbledore')
    expect(page).to_not have_content 'hermione_granger'
  end
end
