class CreateTemplatesMatrixPrograms < ActiveRecord::Migration[5.2]
  def change
    create_table :templates_matrix_programs do |t|
      t.string :name
      t.integer :rating

      t.timestamps
    end
  end
end
