class AddHasProgramsIdAndHasProgramsTypeToTemplatesMatrixProgram < ActiveRecord::Migration[5.2]
  def change
    add_column :templates_matrix_programs, :has_programs_id, :integer
    add_column :templates_matrix_programs, :has_programs_type, :integer
  end
end
