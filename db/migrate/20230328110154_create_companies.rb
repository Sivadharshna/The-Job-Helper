class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :description
      t.string :contact_no
      t.string :address
      t.string :website_link
      t.string :email_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
