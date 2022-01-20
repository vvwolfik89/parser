class CreateDataRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :data_ratings do |t|
      t.belongs_to :part, index: true, foreign_key: true
      t.json :data
      t.json :currency

      t.timestamps
    end
  end
end
