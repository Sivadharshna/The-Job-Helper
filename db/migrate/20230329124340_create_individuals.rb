class CreateIndividuals < ActiveRecord::Migration[6.1]
  def change
    create_table :individuals do |t|
      t.string :name
      t.string :email_id
      t.string :address
      t.integer :age
      t.string :contact_no
      t.integer :experience
      t.float :sslc_percentage
      t.string :hsc_diplomo
      t.float :hsc_diplomo_percentage
      t.string :bachelors_degree
      t.string :masters_degree
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
