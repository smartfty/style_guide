class HomeController < ApplicationController
  def welcome
      @ko_date = Issue.last.korean_date_string
  end

  def help
  end
end
