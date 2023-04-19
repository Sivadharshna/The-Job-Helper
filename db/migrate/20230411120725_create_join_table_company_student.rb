class CreateJoinTableCompanyStudent < ActiveRecord::Migration[6.1]
  def change
    create_join_table :companies, :students do |t|
      t.index [:company_id, :student_id]
      # t.index [:student_id, :company_id]
    end
  end
end
