defmodule TaskBunny.Partition.StatePersister.Stub do
  @moduledoc """
  Stub module for `TaskBunny.Partition` state persistence.
  This is the default implementation, which **does not** persist any
  global partition state.
  """

  alias TaskBunny.Partition.StatePersister

  @behaviour StatePersister

  def init(), do: :ok

  def load() do
    {:error, :not_implemented}
  end

  def store(_data), do: :ok
end
