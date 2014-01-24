require 'app/models/message_queue'
class CreateMessageQueues < ActiveRecord::Migration
  def self.up
    create_table :message_queues do |t|
      t.string :name
      t.string :last_heartbeat
      t.string :last_ingest
      t.string :last_modify
      t.string :last_purge
      t.string :last_pid_ingested
      t.string :last_pid_purged
      t.string :last_pid_modified

      t.timestamps
    end

    MessageQueue.create :name => 'fedora.apim.update'
    MessageQueue.create :name => 'post.index.update'
  end

  def self.down
    drop_table :message_queues
  end
end
