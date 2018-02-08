require 'spec_helper'

describe LoggingWorker::Worker do
  let(:worker) { BlankWorker.new }
  let(:error_worker) { ErrorWorker.new }
  let(:logging_worker) { LogWorker.new }
  let(:new_job_run_worker) { NewJobRunWorker.new }

  specify "creating a job run when the worker starts performing" do
    expect {
      worker.perform
    }.to change {
      LoggingWorker::JobRun.count
    }.by(1)
  end

  specify "setting the completed at time" do
    worker.perform
    expect(worker.job_run.completed_at).to be > 1.second.ago
  end

  specify "setting the completed at time even if there was an error" do
    expect {
      error_worker.perform
    }.to raise_error(RuntimeError)

    expect(error_worker.job_run.completed_at).to be > 1.second.ago
  end

  specify "marking job as successful if the job finished without an error" do
    worker.perform
    expect(worker.job_run.successful).to eq(true)
  end

  specify "marking job as not successful if the job finished with an error" do
    expect {
      error_worker.perform
    }.to raise_error(RuntimeError)

    expect(error_worker.job_run.successful).to eq(false)
  end

  specify "saving the arguments" do
    worker.perform("arg")
    expect(worker.job_run.arguments).to eq(["arg"])
  end

  specify "saving the worker class" do
    worker.perform
    expect(worker.job_run.worker_class).to eq("BlankWorker")
  end

  specify "logging inside of the worker" do
    logging_worker.perform
    expect(logging_worker.job_run.log).to include("DEBUG")
  end

  specify "logging the error and backtrace" do
    expect {
      error_worker.perform
    }.to raise_error(RuntimeError)
    expect(error_worker.job_run.error_class).to eq("RuntimeError")
    expect(error_worker.job_run.error_message).to eq("There was a problem")
    expect(error_worker.job_run.error_backtrace.join).to include("error_worker.rb")
  end

  specify "override the logging class" do
    new_job_run_worker.perform
    expect(new_job_run_worker.job_run).to be_a(::JobRun)
  end

  specify "allow the flush of a log" do
    run = LoggingWorker::JobRun.create
    run.logger.info "Test this"
    expect(LoggingWorker::JobRun.first.log).to eq("")
    run.flush_log!
    expect(LoggingWorker::JobRun.first.log).to include("Test this")
    run.logger.info "Testing more"
    run.flush_log!
    expect(LoggingWorker::JobRun.first.log).to include("Test this")
    expect(LoggingWorker::JobRun.first.log).to include("Testing more")
    run.completed!
    expect(LoggingWorker::JobRun.first.log).to include("Test this")
    expect(LoggingWorker::JobRun.first.log).to include("Testing more")
  end

  specify "self desctruct on complete" do
    run = LoggingWorker::JobRun.create
    run.do_not_record!
    expect {
      run.completed!
    }.to change {
      LoggingWorker::JobRun.count
    }.by(-1)
  end
end
