class AddHospitalIdentifierToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :hospital_identifier, :string
  end
end
