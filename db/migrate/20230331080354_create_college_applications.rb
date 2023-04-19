class CreateCollegeApplications < ActiveRecord::Migration[6.1]
  def change
    create_table :college_applications do |t|
      t.references :college, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
