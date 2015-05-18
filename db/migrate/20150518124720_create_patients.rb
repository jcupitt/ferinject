class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :initials
      t.date :date_of_birth
      t.string :screening_number
      t.date :screening_date
      t.boolean :meets_inclusion_criteria

      t.timestamps
    end
  end
end
