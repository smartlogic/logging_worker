require 'spec_helper'

describe LoggingWorker::Worker do
  let(:worker) { BlankWorker.new }
  let(:error_worker) { ErrorWorker.new }
  let(:logging_worker) { LogWorker.new }

  specify "creating a job run when the worker starts performing" do
    expect {
      worker.perform
    }.to change {
      JobRun.count
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
    worker.perform(true)
    expect(worker.job_run.arguments).to eq([true])
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
end
