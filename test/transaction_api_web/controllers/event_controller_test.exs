defmodule TransactionApiWeb.EventControllerTest do
  use TransactionApiWeb.ConnCase

  alias TransactionApi.Messages
  alias TransactionApi.Messages.Event

  @create_attrs %{city: "some city", email: "some email", ip: "some ip", sender: "some sender", status: "some status", subject: "some subject", template: "some template", ts: "2010-04-17 14:00:00.000000Z", uniq_id: "some uniq_id", user_agent: "some user_agent"}
  @update_attrs %{city: "some updated city", email: "some updated email", ip: "some updated ip", sender: "some updated sender", status: "some updated status", subject: "some updated subject", template: "some updated template", ts: "2011-05-18 15:01:01.000000Z", uniq_id: "some updated uniq_id", user_agent: "some updated user_agent"}
  @invalid_attrs %{city: nil, email: nil, ip: nil, sender: nil, status: nil, subject: nil, template: nil, ts: nil, uniq_id: nil, user_agent: nil}

  def fixture(:event) do
    {:ok, event} = Messages.create_event(@create_attrs)
    event
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get conn, event_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, event_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "city" => "some city",
        "email" => "some email",
        "ip" => "some ip",
        "sender" => "some sender",
        "status" => "some status",
        "subject" => "some subject",
        "template" => "some template",
        "ts" => "2010-04-17 14:00:00.000000Z",
        "uniq_id" => "some uniq_id",
        "user_agent" => "some user_agent"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put conn, event_path(conn, :update, event), event: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, event_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "city" => "some updated city",
        "email" => "some updated email",
        "ip" => "some updated ip",
        "sender" => "some updated sender",
        "status" => "some updated status",
        "subject" => "some updated subject",
        "template" => "some updated template",
        "ts" => "2011-05-18 15:01:01.000000Z",
        "uniq_id" => "some updated uniq_id",
        "user_agent" => "some updated user_agent"}
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put conn, event_path(conn, :update, event), event: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete conn, event_path(conn, :delete, event)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, event_path(conn, :show, event)
      end
    end
  end

  defp create_event(_) do
    event = fixture(:event)
    {:ok, event: event}
  end
end
