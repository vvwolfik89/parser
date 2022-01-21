class CreateBrandInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :brand_infos do |t|
      t.string :brand_name
      t.string :brandid
      t.timestamps
    end
  end
end
