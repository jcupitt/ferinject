class ChangeScreeningNumberInPatients < ActiveRecord::Migration
  def change
    if Rails.env.development?
      change_column :patients, :screening_number, :integer, :default => 0
    else
      change_column :patients, :screening_number, 'integer USING CAST(screening_number AS integer)', :default => 0
    end
  end
end
