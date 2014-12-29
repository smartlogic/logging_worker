module LoggingWorker
  module Worker
    delegate :logger, :to => :job_run

    def job_run_class
      if sidekiq_options_hash && sidekiq_options_hash.has_key?("job_run_class")
        sidekiq_options_hash["job_run_class"]
      else
        LoggingWorker::JobRun
      end
    end

    def job_run
      @job_run ||= job_run_class.new
    end

    def perform(*args)
      job_run.worker_class = self.class.name
      job_run.arguments = args
      job_run.save!

      job_run.log_will_change!

      super

      job_run.successful!
    rescue => e
      job_run.error_class = e.class.name
      job_run.error_message = e.message
      job_run.error_backtrace = e.backtrace
      job_run.save!
      raise e
    ensure
      job_run.completed!
    end
  end
end
