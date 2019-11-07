use Mix.Config

config :task_bunny,
  hosts: [
    default: [connect_options: "amqp://localhost:5672?heartbeat=30"]
  ]
