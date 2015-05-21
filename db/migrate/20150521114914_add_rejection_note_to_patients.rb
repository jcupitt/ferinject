class AddRejectionNoteToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :rejection_note, :string
  end
end
