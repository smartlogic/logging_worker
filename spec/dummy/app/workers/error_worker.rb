class ErrorWorker
  include Sidekiq::Worker
  prepend LoggingWorker::Worker

  def perform
    raise "There was a problem"
  end
end
