class CreateIndividualApplications < ActiveRecord::Migration[6.1]
  def change
    create_table :individual_applications do |t|
      t.references :individual, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
