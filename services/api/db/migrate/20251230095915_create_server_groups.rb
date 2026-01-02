class CreateServerGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :server_groups do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :server_groups, :name, unique: true
  end
end
