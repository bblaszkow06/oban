defmodule Oban.Query.Consumable do
  @moduledoc false

  alias Oban.{Config, Job}

  @type conf :: Config.t()
  @type queue_name :: Oban.queue_name()
  @type queue_opts :: Keyword.t()
  @type queue_meta :: map()
  @type max_time :: DateTime.t()
  @type seconds :: pos_integer()

  @doc """
  Initialize metadata for a queue.

  Queue metadata is used to identify and track subsequent actions such as fetching or staging
  jobs.
  """
  @callback init_queue(conf(), queue_opts()) :: {:ok, queue_meta()} | {:error, term()}

  @doc """
  Update queue metadata such as the concurrency limit or pause status.
  """
  @callback update_queue(conf(), queue_meta(), queue_opts()) :: {:ok, queue_meta} | {:error, term()}

  @doc """
  Fetch available jobs for the given queue, up to configured limits.
  """
  @callback fetch_jobs(conf(), queue_meta()) :: {:ok, [Job.t()]} | {:error, term()}

  @doc """
  Record that a job completed successfully.
  """
  @callback complete_job(conf(), Job.t()) :: :ok

  @doc """
  Record an executing job's errors and either retry or discard it, depending on whether it has
  exhausted its available attempts.
  """
  @callback error_job(conf(), Job.t(), seconds()) :: :ok

  @doc """
  Transition a job to `discarded` and record an optional reason that it shouldn't be ran again.
  """
  @callback discard_job(conf(), Job.t()) :: :ok

  @doc """
  Reschedule an executing job to run some number of seconds in the future.
  """
  @callback snooze_job(conf(), Job.t(), seconds()) :: :ok

  @doc """
  Cancel an `available`, `scheduled` or `retryable` job and mark it as `discarded` to prevent it
  from running again.

  If the job is currently `executing` it should be killed.
  """
  @callback cancel_job(conf(), Job.t()) :: :ok

  @doc """
  Mark a job as `available` while incrementing max_attempts if they've already maxed out.

  Only jobs that are `retryable`, `discarded` or `cancelled` may be retried.
  """
  @callback retry_job(conf(), Job.t()) :: :ok
end
