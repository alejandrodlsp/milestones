class DropSolidQueueTables < ActiveRecord::Migration[8.0]
  def change
    drop_table :solid_queue_jobs, if_exists: true
    drop_table :solid_queue_workers, if_exists: true
  end
end
