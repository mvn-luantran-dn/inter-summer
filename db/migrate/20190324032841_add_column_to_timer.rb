class AddColumnToTimer < ActiveRecord::Migration[5.2]
  def change
    add_column :timers, :is_running, :boolean, default: true
  end
end
