class ChangeScreeningNumberInPatients < ActiveRecord::Migration
  def change
      change_column :patients, :screening_number, :integer, :default => 0
  end
end
