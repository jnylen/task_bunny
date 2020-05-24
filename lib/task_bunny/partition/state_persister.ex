defmodule TaskBunny.Partition.StatePersister do
  @moduledoc """
  Behaviour for the persistence of the global partition state.
  See `TaskBunny.Partition` on how to implement a custom persister module.
  """

  @doc """
  Called when the global state process starts.
  """
  @callback init() :: :ok

  @doc """
  Called when the global state needs to be stored.
  """
  @callback store(data :: binary) :: :ok

  @doc """
  Called when the global state needs to be loaded.
  """
  @callback load() :: {:ok, binary} | {:error, term}
end
