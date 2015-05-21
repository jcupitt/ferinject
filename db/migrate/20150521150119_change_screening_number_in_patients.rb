class ChangeScreeningNumberInPatients < ActiveRecord::Migration
  def change
      change_column :patients, :screening_number, 'integer USING CAST(column_name AS integer)', :default => 0
  end
end
