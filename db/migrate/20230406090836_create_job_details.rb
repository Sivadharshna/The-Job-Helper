class CreateJobDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :job_details do |t|
      t.references :accepted_offer, null: false, foreign_key: true
      t.string :result

      t.timestamps
    end
  end
end
