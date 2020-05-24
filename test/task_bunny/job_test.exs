defmodule TaskBunny.JobTest do
  use ExUnit.Case
  import TaskBunny.QueueTestHelper
  alias TaskBunny.{Job, Queue, Message, QueueTestHelper, Partition}

  @queue "task_bunny.job_test"

  defmodule TestJob do
    use Job
    def perform(_payload), do: :ok
  end

  defmodule TestJob2 do
    use Job

    def queue_key(payload) do
      payload
      |> Map.values()
      |> Enum.join("_")
    end

    def perform(_payload) do
      Process.sleep(1_000)
    end
  end

  setup do
    clean(Queue.queue_with_subqueues(@queue))
    Queue.declare_with_subqueues(:default, @queue)

    :ok
  end

  describe "enqueue" do
    test "enqueues job" do
      payload = %{"foo" => "bar"}
      :ok = TestJob.enqueue(payload, queue: @queue)

      {received, _} = QueueTestHelper.pop(@queue)
      {:ok, %{"payload" => received_payload}} = Message.decode(received)
      assert received_payload == payload
    end

    test "returns an error for wrong option" do
      payload = %{"foo" => "bar"}

      assert {:error, _} =
               TestJob.enqueue(
                 payload,
                 queue: @queue,
                 host: :invalid_host
               )
    end

    test "fails to enqueue job with duplicate queue key" do
      payload = %{"foo" => "bar"}
      :ok = TestJob2.enqueue(payload, queue: @queue)
      assert {:error, :duplicate} == TestJob2.enqueue(payload, queue: @queue)
    end

    test "make sure the queue key was removed after job was processed" do
      Process.sleep(2_000)

      assert false == TestJob2.queue_key(%{"foo" => "bar"}) |> Partition.queued?()
    end
  end

  describe "enqueue!" do
    test "raises an exception for a wrong host" do
      payload = %{"foo" => "bar"}

      assert_raise TaskBunny.Publisher.PublishError, fn ->
        TestJob.enqueue!(payload, queue: @queue, host: :invalid_host)
      end
    end
  end
end
