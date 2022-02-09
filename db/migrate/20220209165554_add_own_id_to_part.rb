class AddOwnIdToPart < ActiveRecord::Migration[7.0]
  def change
    add_column :parts, :own_id, :string
  end
end
