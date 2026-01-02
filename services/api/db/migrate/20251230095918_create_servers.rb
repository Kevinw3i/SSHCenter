class CreateServers < ActiveRecord::Migration[8.1]
  def change
    create_table :servers do |t|
      t.references :server_group, null: false, foreign_key: true
      t.string :site, null: false
      t.string :env, null: false
      t.string :role, null: false
      t.string :ip, null: false

      t.timestamps
    end
  end
end
