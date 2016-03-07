require 'rails_helper'

feature "Instructor can move from course index to new" do

  context "when logged in" do
    before :each do
      create_dumbledore
      sign_in('dumbledore')
      visit '/courses'
    end

    it "course index has a 'New Course' link to new course page" do
      expect(page).to have_content "New Course"
    end
  end
end

feature "Student cannot move from course index to new" do
  context "when logged in" do
    before :each do
      sign_up_as_hermione_granger
      visit '/courses'
    end

    it "course index does not have a 'New Course' link to new course page" do
      expect(page).to_not have_content "New Course"
    end
  end
end

feature "Creating a course" do
  context "when logged in" do
    before :each do
      create_dumbledore
      sign_in('dumbledore')
      visit '/courses/new'
    end

    it "has a new course page" do
      expect(page).to have_content 'New Course'
    end

    it "takes a title and a url" do
      expect(page).to have_content 'Title'
      expect(page).to have_content 'Description'
    end

    it "validates the presence of title" do
      fill_in 'Description', with: 'Learn some magic'
      click_button 'Create New Course'
      expect(page).to have_content 'New Course'
      expect(page).to have_content "Title can't be blank"
    end

    it "validates the presence of description" do
      fill_in 'Title', with: 'magic 101'
      click_button 'Create New Course'
      expect(page).to have_content 'New Course'
      expect(page).to have_content "Description can't be blank"
    end

    it "redirects to the course show page" do
      fill_in 'Description', with: 'Some magic'
      fill_in 'Title', with: 'Course Title'
      click_button 'Create New Course'

      expect(current_path).to match(/^\/courses\/(\d)+/)
      expect(page).to have_content 'Course Title'
      expect(page).to have_content 'Taught by dumbledore'
    end

    context "on failed save" do
      before :each do
        fill_in 'Title', with: 'google'
      end

      it "displays the new course form again" do
        expect(page).to have_content 'New Course'
      end

      it "has a pre-filled form (with the data previously input)" do
        expect(find_field('Title').value).to eq('google')
      end

      it "still allows for a successful save" do
        fill_in 'Description', with: 'Magic Description'
        click_button 'Create New Course'
        expect(page).to have_content 'Magic Description'
      end
    end
  end

  context "when logged out" do
    it "redirects to the login page" do
      visit '/courses/new'
      expect(page).to have_content 'Sign In'
    end
  end
end

feature "Seeing all courses" do
  context "when logged in" do
    before :each do
      create_dumbledore
      sign_in("dumbledore")
      make_course("Dumbledore Course", "I teach magic")
      click_on "Sign Out"
      create_instructor('snape')
      sign_in('snape')
      make_course("Snape Course", "I make potions")
      make_course("Potions Course", "You make potions")
      visit '/courses'
    end

    it "shows all the courses for all users" do
      expect(page).to have_content 'Dumbledore Course'
      expect(page).to have_content 'Snape Course'
      expect(page).to have_content 'Potions Course'
    end

    it "shows the current user's username" do
      expect(page).to have_content 'snape'
    end

    it "courses to each of the course's show page via course titles" do
      click_link 'Dumbledore Course'
      expect(page).to have_content 'Dumbledore Course'
      expect(page).to_not have_content 'Snape Course'
      expect(page).to_not have_content 'Potions Course'
    end
  end

  context "when logged out" do
    it "redirects to the login page" do
      visit '/courses'
      expect(page).to have_content 'Sign In'
    end
  end

  context "when signed in as another user" do
    before :each do
      create_dumbledore
      sign_in('dumbledore')
      click_button 'Sign Out'
      create_instructor('snape')
      sign_in('snape')
      make_course("Potions", "Make some potions")
      click_button 'Sign Out'

      sign_up('ron_weasley')
    end

    it "shows others courses" do
      visit '/courses'
      expect(page).to have_content 'Potions'
    end
  end
end

feature "Showing a course" do
  context "when logged in" do
    before :each do
      create_dumbledore
      sign_in('dumbledore')
      make_course("Magic Class", "Magic is taught")
      visit '/courses'
      click_link 'Magic Class'
    end

    it "shows the current user's username" do
      expect(page).to have_content 'dumbledore'
    end

    it "displays the course title" do
      expect(page).to have_content 'Magic Class'
    end

    it "displays the course url" do
      expect(page).to have_content 'Magic is taught'
    end

    it "displays a course back to the course index" do
      expect(page).to have_content "Courses"
    end
  end
end

feature "Editing a course" do
  before :each do
    create_dumbledore
    sign_in('dumbledore')
    make_course("Magic Class", "I teach magic")
    visit '/courses'
    click_link 'Magic Class'
  end

  it "has a course on the show page to edit a course" do
    expect(page).to have_content 'Edit Course'
  end

  it "does not have a show page to edit when logged in as a student" do
    click_button 'Sign Out'
    expect(page).to_not have_content 'Edit Course'
  end

  it "shows a form to edit the course" do
    click_link 'Edit Course'
    expect(page).to have_content 'Title'
    expect(page).to have_content 'Description'
  end

  it "has all the data pre-filled" do
    click_link 'Edit Course'
    expect(find_field('Title').value).to eq('Magic Class')
    expect(find_field('Description').value).to eq('I teach magic')
  end

  it "shows errors if editing fails" do
    click_link 'Edit Course'
    fill_in 'Description', with: ''
    click_button 'Update Course'
    expect(page).to have_content "Edit Course"
    expect(page).to have_content "Description can't be blank"
  end

  context "on successful update" do
    before :each do
      click_link 'Edit Course'
    end

    it "redirects to the course show page" do
      fill_in 'Title', with: 'Edited Title'
      click_button 'Update Course'
      expect(page).to have_content 'Edited Title'
    end
  end
end
