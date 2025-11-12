class TestsController < ApplicationController
  def ping
    user = User.find(params[:id])
    ActionCable.server.broadcast(
      "notifications:#{user.to_gid_param}",
      { text: "Ping from test controller" }
    )
    render json: { status: "sent", user: user.id }
  end
end
