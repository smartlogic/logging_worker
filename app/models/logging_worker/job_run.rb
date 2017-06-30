class LoggingWorker::JobRun < ApplicationRecord
  after_initialize do
    self[:log] ||= ""
  end

  def logger
    @logger ||= Logger.new(StringIO.new(log))
  end

  def successful!
    self.successful = true
  end

  def completed!
    self.successful = false if successful.nil?
    self.completed_at = Time.now
    save!
  end
end
