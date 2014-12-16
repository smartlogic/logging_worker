# LoggingWorker

LoggingWorker lets you create a record each time a background worker is run. It handles this automatically for you. There will be a new `JobRun` model that contains each run.

## Installation

Add logging_worker to your Gemfile

```ruby
  gem 'logging_worker', :github => 'smartlogic/logging_worker'
```

Bundle it!

    $ bundle install

Install migrations

    $ rake logging_worker_engine:install:migrations

Add to your workers.

```ruby
class MyWorker
  include Sidekiq::Worker
  # Using prepend is VERY important
  prepend LoggingWorker::Worker

  # ...
end
```

## JobRun

Each time a background job is performed a new `JobRun` will be created. `JobRun` has the following attributes:

- `worker_class` worker class that performed the job
- `arguments` arguments used for running the job
- `successful` if the job finished successfully, with no errors
- `completed_at` when the job finished, regardless of success status
- `log` Log of the job
- `error_message` if the job errored, the error message
- `error_backtrace` if the job errored, the error backtrace
