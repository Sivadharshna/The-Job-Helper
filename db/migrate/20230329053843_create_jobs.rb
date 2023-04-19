class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|
      t.string :name
      t.string :description
      t.float :salary
      t.integer :minimum_experience
      t.string :mode
      t.string :minimum_educational_qualification
      t.float :expected_sslc_percentage
      t.float :expected_hsc_percentage
      t.float :expected_cgpa
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
