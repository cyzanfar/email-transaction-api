defmodule TransactionApi.MessagesTest do
  use TransactionApi.DataCase

  alias TransactionApi.Messages

  describe "events" do
    alias TransactionApi.Messages.Event

    @valid_attrs %{city: "some city", email: "some email", ip: "some ip", sender: "some sender", status: "some status", subject: "some subject", template: "some template", ts: "2010-04-17 14:00:00.000000Z", uniq_id: "some uniq_id", user_agent: "some user_agent"}
    @update_attrs %{city: "some updated city", email: "some updated email", ip: "some updated ip", sender: "some updated sender", status: "some updated status", subject: "some updated subject", template: "some updated template", ts: "2011-05-18 15:01:01.000000Z", uniq_id: "some updated uniq_id", user_agent: "some updated user_agent"}
    @invalid_attrs %{city: nil, email: nil, ip: nil, sender: nil, status: nil, subject: nil, template: nil, ts: nil, uniq_id: nil, user_agent: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messages.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Messages.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Messages.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Messages.create_event(@valid_attrs)
      assert event.city == "some city"
      assert event.email == "some email"
      assert event.ip == "some ip"
      assert event.sender == "some sender"
      assert event.status == "some status"
      assert event.subject == "some subject"
      assert event.template == "some template"
      assert event.ts == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert event.uniq_id == "some uniq_id"
      assert event.user_agent == "some user_agent"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, event} = Messages.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.city == "some updated city"
      assert event.email == "some updated email"
      assert event.ip == "some updated ip"
      assert event.sender == "some updated sender"
      assert event.status == "some updated status"
      assert event.subject == "some updated subject"
      assert event.template == "some updated template"
      assert event.ts == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert event.uniq_id == "some updated uniq_id"
      assert event.user_agent == "some updated user_agent"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_event(event, @invalid_attrs)
      assert event == Messages.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Messages.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Messages.change_event(event)
    end
  end

  describe "event_details" do
    alias TransactionApi.Messages.EventDetail

    @valid_attrs %{event_id: 42, ts: "2010-04-17 14:00:00.000000Z", url: "some url"}
    @update_attrs %{event_id: 43, ts: "2011-05-18 15:01:01.000000Z", url: "some updated url"}
    @invalid_attrs %{event_id: nil, ts: nil, url: nil}

    def event_detail_fixture(attrs \\ %{}) do
      {:ok, event_detail} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messages.create_event_detail()

      event_detail
    end

    test "list_event_details/0 returns all event_details" do
      event_detail = event_detail_fixture()
      assert Messages.list_event_details() == [event_detail]
    end

    test "get_event_detail!/1 returns the event_detail with given id" do
      event_detail = event_detail_fixture()
      assert Messages.get_event_detail!(event_detail.id) == event_detail
    end

    test "create_event_detail/1 with valid data creates a event_detail" do
      assert {:ok, %EventDetail{} = event_detail} = Messages.create_event_detail(@valid_attrs)
      assert event_detail.event_id == 42
      assert event_detail.ts == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert event_detail.url == "some url"
    end

    test "create_event_detail/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_event_detail(@invalid_attrs)
    end

    test "update_event_detail/2 with valid data updates the event_detail" do
      event_detail = event_detail_fixture()
      assert {:ok, event_detail} = Messages.update_event_detail(event_detail, @update_attrs)
      assert %EventDetail{} = event_detail
      assert event_detail.event_id == 43
      assert event_detail.ts == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert event_detail.url == "some updated url"
    end

    test "update_event_detail/2 with invalid data returns error changeset" do
      event_detail = event_detail_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_event_detail(event_detail, @invalid_attrs)
      assert event_detail == Messages.get_event_detail!(event_detail.id)
    end

    test "delete_event_detail/1 deletes the event_detail" do
      event_detail = event_detail_fixture()
      assert {:ok, %EventDetail{}} = Messages.delete_event_detail(event_detail)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_event_detail!(event_detail.id) end
    end

    test "change_event_detail/1 returns a event_detail changeset" do
      event_detail = event_detail_fixture()
      assert %Ecto.Changeset{} = Messages.change_event_detail(event_detail)
    end
  end
end
