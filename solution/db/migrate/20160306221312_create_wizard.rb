class CreateWizard < ActiveRecord::Migration
  def change
    create_table :wizards do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :session_token, null: false

      t.timestamps
    end
    add_index :wizards, :username, unique: true
  end
end
