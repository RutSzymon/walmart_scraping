module ApplicationHelper
  def flashes
    { notice: "info", alert: "danger", error: "danger", success: "success" }
  end
end