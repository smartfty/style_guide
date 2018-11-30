module ApplicationHelper
  def current_issue
    Issue.last
  end
end
