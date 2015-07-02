class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|

      t.attachment :asset, null: false

      t.string :name_of_model, null: false
      t.string :delimiter

      t.timestamps null: false
    end
  end
end
