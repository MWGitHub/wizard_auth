class CreateCourse < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.integer :instructor_id, null: false

      t.timestamps
    end
    add_index :courses, :instructor_id
  end
end
