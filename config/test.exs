use Mix.Config

config :logger, backends: [{LoggerFileBackend, :log_file}]
config :logger, :log_file, level: :debug, path: "logs/test.log"

config :task_bunny,
  hosts: [
    default: [connect_options: "amqp://localhost:5672?heartbeat=30"]
  ]
