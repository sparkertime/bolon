defmodule BolonWeb.SlackController do
  use BolonWeb, :controller

  def rollstats(conn, %{"user_id" => user, "text" => text}) do
    %{fields: fields, total: total} = Bolon.Stats.roll_stats()
    addendum = if(total < 54) do
      "\nThis character's average attribute score is less than 9 - unlucky! By the grace of the bold astral bear Bolon, you are granted a choice between the following two boons:\n> 1. This character gets one re-roll per session.\n> *or*\n> 2. You are granted another `/rollstats` for this character as if this result never happened (e.g. you do not choose between the two sets once you see the second)."
    else
      ""
    end

    name = if((text || "") == "") do "a new character" else text end

    put_status(conn, 200)
    |> json(%{
      response_type: "in_channel",
      blocks: [
        %{
          type: "section", 
          text: %{
            type: "mrkdwn",
            text: "<@#{user}> has breathed life into *#{name}*!#{addendum}"
          }
        },
        %{
          type: "section",
          fields: wrap_stat_fields(fields)
        }
      ]
    })
  end

  defp wrap_stat_fields(stats) do
    Enum.map(stats, fn str -> 
      %{ type: "mrkdwn", text: str }
    end)
  end
end