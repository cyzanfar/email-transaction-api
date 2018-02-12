defmodule TransactionApiWeb.EventView do
  use TransactionApiWeb, :view
  alias TransactionApiWeb.EventView

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{id: event.id,
      sender: event.sender,
      uniq_id: event.uniq_id,
      ts: event.ts,
      template: event.template,
      subject: event.subject,
      email: event.email,
      status: event.status,
      ip: event.ip,
      city: event.city,
      user_agent: event.user_agent}
  end
end
