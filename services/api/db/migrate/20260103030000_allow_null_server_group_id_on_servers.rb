class AllowNullServerGroupIdOnServers < ActiveRecord::Migration[8.1]
  def change
    change_column_null :servers, :server_group_id, true
  end
end
