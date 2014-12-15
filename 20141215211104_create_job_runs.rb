class CreateJobRuns < ActiveRecord::Migration
  def change
    create_table :job_runs do |t|
      t.string :worker_class
      t.string :arguments, :array => true
      t.boolean :successful
      t.timestamp :completed_at
      t.text :log

      t.timestamps
    end
  end
end
