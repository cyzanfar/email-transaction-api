defmodule TransactionApiWeb.EventDetailControllerTest do
  use TransactionApiWeb.ConnCase

  alias TransactionApi.Messages
  alias TransactionApi.Messages.EventDetail

  @create_attrs %{event_id: 42, ts: "2010-04-17 14:00:00.000000Z", url: "some url"}
  @update_attrs %{event_id: 43, ts: "2011-05-18 15:01:01.000000Z", url: "some updated url"}
  @invalid_attrs %{event_id: nil, ts: nil, url: nil}

  def fixture(:event_detail) do
    {:ok, event_detail} = Messages.create_event_detail(@create_attrs)
    event_detail
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all event_details", %{conn: conn} do
      conn = get conn, event_detail_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event_detail" do
    test "renders event_detail when data is valid", %{conn: conn} do
      conn = post conn, event_detail_path(conn, :create), event_detail: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, event_detail_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "event_id" => 42,
        "ts" => "2010-04-17 14:00:00.000000Z",
        "url" => "some url"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, event_detail_path(conn, :create), event_detail: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event_detail" do
    setup [:create_event_detail]

    test "renders event_detail when data is valid", %{conn: conn, event_detail: %EventDetail{id: id} = event_detail} do
      conn = put conn, event_detail_path(conn, :update, event_detail), event_detail: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, event_detail_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "event_id" => 43,
        "ts" => "2011-05-18 15:01:01.000000Z",
        "url" => "some updated url"}
    end

    test "renders errors when data is invalid", %{conn: conn, event_detail: event_detail} do
      conn = put conn, event_detail_path(conn, :update, event_detail), event_detail: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event_detail" do
    setup [:create_event_detail]

    test "deletes chosen event_detail", %{conn: conn, event_detail: event_detail} do
      conn = delete conn, event_detail_path(conn, :delete, event_detail)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, event_detail_path(conn, :show, event_detail)
      end
    end
  end

  defp create_event_detail(_) do
    event_detail = fixture(:event_detail)
    {:ok, event_detail: event_detail}
  end
end
