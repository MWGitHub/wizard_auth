class AddInstructorToWizard < ActiveRecord::Migration
  def change
    add_column :wizards, :instructor, :boolean, null: false, default: false
  end
end
