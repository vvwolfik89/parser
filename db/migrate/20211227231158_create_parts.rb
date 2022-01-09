class CreateParts < ActiveRecord::Migration[7.0]
  def change
    create_table :parts do |t|
      t.string :title
      t.string :brand
      t.text :describe
      t.string :detail_num
      t.string :o_e

      t.timestamps
    end
  end
end
