class CreateTemplatesMatrixUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :templates_matrix_users do |t|
      t.references :user, foreign_key: true, null: true
      t.string :name
      t.integer :reaction
      t.integer :intuition
      t.integer :logic
      t.integer :willpower
      t.integer :computer
      t.integer :cybercombat
      t.integer :data_search
      t.integer :electronic_warfare
      t.integer :hacking
      t.text :programs
      t.string :access_id

      t.timestamps
    end
  end
end
