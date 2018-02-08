class LoggingWorker::JobRun < ApplicationRecord
  after_initialize do
    self[:log] ||= ""
    @do_not_record = false
  end

  def logger
    @logger ||= Logger.new(StringIO.new(log))
  end

  def flush_log!
    log_will_change!
    save!
  end

  def do_not_record!
    @do_not_record = true
  end

  def successful!
    self.successful = true
  end

  def completed!
    if @do_not_record
      destroy!
    else
      self.successful = false if successful.nil?
      self.completed_at = Time.now
      save!
    end
  end
end
