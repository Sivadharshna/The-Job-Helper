class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students do |t|
      t.string :name
      t.float :sslc_percentage
      t.string :hsc_diplomo
      t.float :hsc_diplomo_percentage
      t.float :cgpa
      t.integer :graduation_year
      t.string :placement_status, :default => 'Yet to be placed'
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
