defmodule Mix.Tasks.Db.Start do
    use Mix.Task
    @shortdoc "Runs Postgres inside docker on port 5432"

    def run(_cmd_args) do
        Mix.shell.cmd("docker run --name yet_another_chat_db -p 5432:5432 -d postgres")
    end
end