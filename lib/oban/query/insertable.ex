defmodule Oban.Query.Insertable do
  @moduledoc false

  alias Ecto.Multi
  alias Oban.{Config, Job}

  @type conf :: Config.t()
  @type changeset_or_fun :: Job.changeset() | Job.changeset_fun()
  @type changeset_list_or_fun :: Job.changeset_list() | Job.changeset_list_fun()

  @doc """
  Insert a job from a changeset.

  If the job is configured to be unique then an existing job matching the unique conditions may be
  returned instead.
  """
  @callback insert_job(conf(), Job.changeset()) :: {:ok, Job.t()} | {:error, term()}

  @doc """
  Append building a job from a changeset or function into a multi operation.
  """
  @callback insert_job(conf(), Multi.t(), Multi.name(), changeset_or_fun()) :: Multi.t()

  @doc """
  Insert multiple jobs in a single call.
  """
  @callback insert_all_jobs(conf(), Job.changeset_list()) :: [Job.t()]

  @doc """
  Append inserting multiple jobs from a list of changesets or a function into a multi operation.
  """
  @callback insert_all_jobs(conf(), Multi.t(), Multi.name(), changeset_list_or_fun()) :: Multi.t()
end
