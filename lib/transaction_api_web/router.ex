defmodule TransactionApiWeb.Router do
  use TransactionApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TransactionApiWeb do
    pipe_through :api

    resources "/events", EventController, except: [:new, :edit]
    resources "/event_details", EventDetailController, except: [:new, :edit]
  end
end
