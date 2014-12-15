class BlankWorker
  include Sidekiq::Worker
  prepend LoggingWorker::Worker

  def perform(extra = nil)
  end
end
