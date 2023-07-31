class CreateTimeReports < ActiveRecord::Migration[7.0]
  def change
    create_table :time_reports do |t|
      t.date :date
      t.decimal :hours_worked
      t.string :employee_id
      t.string :job_group

      t.timestamps
    end
  end
end
