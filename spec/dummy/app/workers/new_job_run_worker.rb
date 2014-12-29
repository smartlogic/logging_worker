class NewJobRunWorker
  include Sidekiq::Worker
  prepend LoggingWorker::Worker

  sidekiq_options({
    :logging_worker => ::JobRun
  })

  def perform
  end
end
