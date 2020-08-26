defmodule ElixirRadar do
  use Crawly.Spider

  @impl Crawly.Spider
  def base_url(), do: "https://elixir-radar.com"

  @impl Crawly.Spider
  def init() do
    [
      start_urls: [
        "https://elixir-radar.com/jobs"
      ]
    ]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)
    items = document |> Floki.find(".job-board-job") |> Enum.map(&parse_item_block/1)

    requests = document
               |> Floki.find(".pagination__button")
               |> Floki.attribute("a", "href")
               |> Enum.uniq()
               |> Enum.map(&build_absolute_url/1)
               |> Enum.map(&Crawly.Utils.request_from_url/1)

    %Crawly.ParsedItem{:items => items, :requests => requests}
  end

  defp parse_item_block(block) do
    %{title: block |> Floki.find(".job-board-job-title") |> Floki.text |> String.split("\n") |> List.first(),
      location: block |> Floki.find(".job-board-job-location") |> Floki.text |> String.trim,
      description: block |> Floki.find(".job-board-job-description") |> Floki.text,
      url: block |> Floki.find(".job-board-job-title") |> Floki.attribute("a", "href") 
    }
  end

  defp build_absolute_url(url), do: URI.merge(base_url(), url) |> to_string()

end
