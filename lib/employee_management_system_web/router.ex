defmodule EmployeeManagementSystemWeb.Router do
  use EmployeeManagementSystemWeb, :router

  import EmployeeManagementSystemWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {EmployeeManagementSystemWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", EmployeeManagementSystemWeb do
    pipe_through(:browser)

    live("/", PageLive.Index, :index)
  end

  scope "/", EmployeeManagementSystemWeb do
    pipe_through([:browser, :require_authenticated_user])
    live("/messages", MessageLive.Index, :index)
    live("/messages/new", MessageLive.Index, :new)
    live("/messages/:id/edit", MessageLive.Index, :edit)

    live("/messages/:id", MessageLive.Show, :show)
    live("/messages/:id/show/edit", MessageLive.Show, :edit)

    live("/chats", ChatLive.Index, :index)
    live("/chats/:id", ChatLive.Show, :show)
    live("chats/:id/addimage", ChatLive.Show, :addimage)
    live("/groups/newgroup", ChatLive.Index, :newgroup)

    live("/groups", GroupLive.Index, :index)
    live("/groups/new", GroupLive.Index, :new)
    live("/groups/:id/edit", GroupLive.Index, :edit)

    live("/groups/:id", GroupLive.Show, :show)
    live("groups/:id/addgroupmember", GroupLive.Show, :addgroupmember)
    live("/groups/:id/show/edit", GroupLive.Show, :edit)

    live("/group_members", GroupMemberLive.Index, :index)
    live("/group_members/new", GroupMemberLive.Index, :new)
    live("/group_members/:id/edit", GroupMemberLive.Index, :edit)

    live("/group_members/:id", GroupMemberLive.Show, :show)
    live("/group_members/:id/show/edit", GroupMemberLive.Show, :edit)

    live("/group_messages", GroupMessageLive.Index, :index)
    live("/group_messages/new", GroupMessageLive.Index, :new)
    live("/group_messages/:id/edit", GroupMessageLive.Index, :edit)

    live("/group_messages/:id", GroupMessageLive.Show, :show)
    live("/group_messages/:id/show/edit", GroupMessageLive.Show, :edit)

    live("/tasks", TaskLive.Index, :index)
    live("/tasks/:id/newtask", TaskLive.Show, :newtask)
    live("/tasks/:id/:task_id/edit", TaskLive.Show, :edit)
    live("/tasks/:id", TaskLive.Show, :show)
    live("mytasks/:id", TaskLive.Mytasks, :show)
    live("/tasks/:id/:task_id/newreview", TaskLive.Show, :newreview)
    live("/tasks/:id/:task_id/:review_id/edit", TaskLive.Show, :editreview)

    live("/events", EventLive.Index, :index)
    live("/events/new", EventLive.Index, :new)
    live("/events/:id/edit", EventLive.Index, :edit)

    live("/events/:id", EventLive.Show, :show)
    live("/events/:id/show/edit", EventLive.Show, :edit)

    # live "/reviews", ReviewLive.Index, :index
    # live "/reviews/new", ReviewLive.Index, :new
    # live "/reviews/:id/edit", ReviewLive.Index, :edit

    # live "/reviews/:id", ReviewLive.Show, :show
    # live "/reviews/:id/show/edit", ReviewLive.Show, :edit

    # live "/tasks/:id/show/edit", TaskLive.Show, :edit
  end

  scope "/", EmployeeManagementSystemWeb do
    pipe_through([:browser, :require_authenticated_admin])

    live("/adminpanel", AdminPanelLive.Index, :index)
    live("/adminpanel/:id", AdminPanelLive.Show, :show)
  end

  # Other scopes may use custom stacks.
  # scope "/api", EmployeeManagementSystemWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: EmployeeManagementSystemWeb.Telemetry)
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  ## Authentication routes

  scope "/", EmployeeManagementSystemWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    get("/users/register", UserRegistrationController, :new)
    post("/users/register", UserRegistrationController, :create)
    get("/users/log_in", UserSessionController, :new)
    post("/users/log_in", UserSessionController, :create)
    get("/users/reset_password", UserResetPasswordController, :new)
    post("/users/reset_password", UserResetPasswordController, :create)
    get("/users/reset_password/:token", UserResetPasswordController, :edit)
    put("/users/reset_password/:token", UserResetPasswordController, :update)
  end

  scope "/", EmployeeManagementSystemWeb do
    pipe_through([:browser, :require_authenticated_user])

    get("/users/settings", UserSettingsController, :edit)
    put("/users/settings", UserSettingsController, :update)
    get("/users/settings/confirm_email/:token", UserSettingsController, :confirm_email)
  end

  scope "/", EmployeeManagementSystemWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)
    get("/users/confirm", UserConfirmationController, :new)
    post("/users/confirm", UserConfirmationController, :create)
    get("/users/confirm/:token", UserConfirmationController, :edit)
    post("/users/confirm/:token", UserConfirmationController, :update)
  end
end
