class CreateColleges < ActiveRecord::Migration[6.1]
  def change
    create_table :colleges do |t|
      t.string :name
      t.string :email_id
      t.string :contact_no
      t.string :address
      t.string :website_link
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
