class CreateProxyServers < ActiveRecord::Migration[7.0]
  def change
    create_table :proxy_servers do |t|
      t.string :server
      t.integer :port

      t.timestamps
    end
  end
end
