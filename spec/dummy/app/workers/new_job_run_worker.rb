class NewJobRunWorker
  include Sidekiq::Worker
  prepend LoggingWorker::Worker

  sidekiq_options({
    :job_run_class => ::JobRun
  })

  def perform
  end
end
