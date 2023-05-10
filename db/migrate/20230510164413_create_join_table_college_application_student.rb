class CreateJoinTableCollegeApplicationStudent < ActiveRecord::Migration[6.1]
  def change
    create_join_table :college_applications, :students do |t|
      # t.index [:college_application_id, :student_id]
      # t.index [:student_id, :college_application_id]
    end
  end
end
