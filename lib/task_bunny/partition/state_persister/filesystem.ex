defmodule TaskBunny.Partition.StatePersister.Filesystem do
  @moduledoc """
  Module implementing filesystem storage for `TaskBunny.Partition` state persistence.
  The path in which the state files are saved can be configured like this:
      config :roger, TaskBunny.Partition.StatePersister.Filesystem,
        path: "/path/to/files"
  Note that in a distributed setup, it does not make sense to use this
  persister unless you are sharing the filesystem between the multiple
  machines.
  """

  alias TaskBunny.Partition.StatePersister

  @behaviour StatePersister

  @storage_dir Application.get_env(:roger, __MODULE__, [])[:path] || "/tmp"

  @file_name "part"

  def init() do
    :ok
  end

  def load() do
    File.read(filename(@file_name))
  end

  def store(data) do
    File.write(filename(@file_name), data)
  end

  defp filename(name) do
    :filename.join(@storage_dir, "#{name}.state")
  end
end
