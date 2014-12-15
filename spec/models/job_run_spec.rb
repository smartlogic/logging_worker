require 'spec_helper'

describe JobRun do
  specify "array arguments column" do
    job_run = JobRun.create(:arguments => ["one", "two"])
    job_run = JobRun.find(job_run.id)
    expect(job_run.arguments).to be_a(Array)
  end

  specify "logging during the run" do
    job_run = JobRun.new
    job_run.logger.info("test")
    expect(job_run.log).to include("test")
  end
end
