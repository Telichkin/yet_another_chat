defmodule Mix.Tasks.Db.Start do
    use Mix.Task
    @shortdoc "Runs Postgres inside docker on port 5432"

    def run(_cmd_args) do
        db_name = "yet_another_chat_db"
        Mix.shell.cmd("docker rm -f #{db_name} ; docker run --name #{db_name} -p 5432:5432 -d postgres")
    end
end