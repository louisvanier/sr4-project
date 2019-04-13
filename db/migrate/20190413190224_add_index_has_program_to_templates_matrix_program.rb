class AddIndexHasProgramToTemplatesMatrixProgram < ActiveRecord::Migration[5.2]
  def change
    add_index :templates_matrix_programs, [:has_programs_id, :has_programs_type], name: 'index_templates_matrix_programs_on_has_programs'
  end
end
