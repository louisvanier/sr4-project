class RemoveProgramsFromTemplatesMatrixUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :templates_matrix_users, :programs
  end
end
