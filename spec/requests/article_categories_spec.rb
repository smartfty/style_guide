require 'rails_helper'

RSpec.describe "ArticleCategories", type: :request do
  describe "GET /article_categories" do
    it "works! (now write some real specs)" do
      get article_categories_path
      expect(response).to have_http_status(200)
    end
  end
end
