class LogWorker
  include Sidekiq::Worker
  prepend LoggingWorker::Worker

  def perform
    logger.debug("Logging")
  end
end
