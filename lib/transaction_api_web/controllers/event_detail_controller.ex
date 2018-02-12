defmodule TransactionApiWeb.EventDetailController do
  use TransactionApiWeb, :controller

  alias TransactionApi.Messages
  alias TransactionApi.Messages.EventDetail

  action_fallback TransactionApiWeb.FallbackController

  def index(conn, _params) do
    event_details = Messages.list_event_details()
    render(conn, "index.json", event_details: event_details)
  end

  def create(conn, %{"event_detail" => event_detail_params}) do
    with {:ok, %EventDetail{} = event_detail} <- Messages.create_event_detail(event_detail_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", event_detail_path(conn, :show, event_detail))
      |> render("show.json", event_detail: event_detail)
    end
  end

  def show(conn, %{"id" => id}) do
    event_detail = Messages.get_event_detail!(id)
    render(conn, "show.json", event_detail: event_detail)
  end

  def update(conn, %{"id" => id, "event_detail" => event_detail_params}) do
    event_detail = Messages.get_event_detail!(id)

    with {:ok, %EventDetail{} = event_detail} <- Messages.update_event_detail(event_detail, event_detail_params) do
      render(conn, "show.json", event_detail: event_detail)
    end
  end

  def delete(conn, %{"id" => id}) do
    event_detail = Messages.get_event_detail!(id)
    with {:ok, %EventDetail{}} <- Messages.delete_event_detail(event_detail) do
      send_resp(conn, :no_content, "")
    end
  end
end
