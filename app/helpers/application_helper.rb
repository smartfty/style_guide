module ApplicationHelper
  def current_issue
    if session[:current_issue] 
      session[:current_issue]
      Issue.find(session[:current_issue]["id"])
    else
      Issue.last
    end 
  end

  def ko_date
    current_issue.korean_date_string
  end

  def class_if_current_page(entry:)
    selected = is_current_page?(entry)

    class_name = 'active'
    unless current_page?(entry[:href])
      class_name += ' open'
    end
    class_name if selected
  end

  def filter_tags_from_title(title)
    title.downcase
  end

  def i18n_from_title(prefix:, title:)
    "#{prefix}#{title.downcase.gsub(' ', '_')}"
  end

  private
  def is_current_page?(entry)
    if current_page?(entry[:href])
      true
    elsif entry[:children]
      entry[:children].any?(&method(:is_current_page?))
    else
      false
    end
  end
end
