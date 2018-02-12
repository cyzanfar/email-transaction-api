defmodule TransactionApiWeb.EventDetailView do
  use TransactionApiWeb, :view
  alias TransactionApiWeb.EventDetailView

  def render("index.json", %{event_details: event_details}) do
    %{data: render_many(event_details, EventDetailView, "event_detail.json")}
  end

  def render("show.json", %{event_detail: event_detail}) do
    %{data: render_one(event_detail, EventDetailView, "event_detail.json")}
  end

  def render("event_detail.json", %{event_detail: event_detail}) do
    %{id: event_detail.id,
      url: event_detail.url,
      ts: event_detail.ts,
      event_id: event_detail.event_id}
  end
end
