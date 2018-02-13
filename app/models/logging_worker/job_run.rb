class LoggingWorker::JobRun < ApplicationRecord
  after_initialize do
    self[:log] ||= ""
    @do_not_record = false
  end

  def logger
    @io ||= StringIO.new
    @logger ||= Logger.new(@io)
  end

  def flush_log!(save_to_db = true)
    @io.rewind
    content = @io.read
    self.log += content
    save! if save_to_db
    @io.close
    @logger.close
    @io = nil
    @logger = nil
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
      logger # make sure we've got it
      flush_log!(false)
      save!
    end
  end
end
