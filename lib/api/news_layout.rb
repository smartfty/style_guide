module Api
  class NewsLayout < Sinatra::Base

    get '/news_layout_hello' do
      "Welcome to news_layout!"
    end

    # create new issue
    get '/new_issue/:date' do
      "params:#{params} params[:date]#{params[:date]}"
    end

    # get issue_plan
    get '/issue_plan/:date' do
      issue_plan = [
        [[0,0,3,3],[0,3,3,3]],
      ]
      "#{issue_plan.to_yaml}"
    end

    get '/refresh_page/:date/:page' do
      # "page_number:#{payload[:page_number]}"
      "In refresh_page #{params[:page]}"
    end

    # update page content
    post '/api/v1/layout_article/:date/:page/:order' do
      date  = params[:date]
      page  = params[:page].to_i
      order = params[:order].to_i
      # p     = Page.where(page_number: page).first
      working_article   = WorkingArticle.where(page_id: p.id, order: order).first
      if working_article
        current_page_id     = working_article.page_id
        new_date            = params[:payload].dup
        new_date['page_id'] = current_page_id
        working_article.update_columns(new_data)
        working_article.generate_pdf
        # working_article.update_page_pdf
        "http:localhost/#{date}/#{page}/#{order}.jpg"
      else
        "not fount!!!: /#{page}/#{order}:#{order}"
      end
    end
  end
end
