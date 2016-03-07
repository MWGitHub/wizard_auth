require 'rails_helper'

RSpec.describe "Wizard", :type => :model do
  describe "password encryption" do
    it "does not validate instructor and defaults to false" do
      Wizard.create!(username: "harry_potter", password: "password")
      wizard = Wizard.find_by(username: 'harry_potter')
      expect(wizard.instructor).to be_falsey
    end

    it "allows creating an instructor in the console" do
      Wizard.create!(username: "dumbledore", password: "wizard",
        instructor: true)
      wizard = Wizard.find_by(username: 'dumbledore')
      expect(wizard.instructor).to be_truthy
    end

    it "does not save passwords to the database" do
      Wizard.create!(username: "harry_potter", password: "password")
      wizard = Wizard.find_by_username("harry_potter")
      expect(wizard.password).not_to be("password")
    end

    it "encrypts the password using BCrypt" do
      expect(BCrypt::Password).to receive(:create)
      Wizard.new(username: "harry_potter", password: "password")
    end
  end
end
