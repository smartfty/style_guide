require "rails_helper"

RSpec.describe ArticleSubcategoriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/article_subcategories").to route_to("article_subcategories#index")
    end

    it "routes to #new" do
      expect(:get => "/article_subcategories/new").to route_to("article_subcategories#new")
    end

    it "routes to #show" do
      expect(:get => "/article_subcategories/1").to route_to("article_subcategories#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/article_subcategories/1/edit").to route_to("article_subcategories#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/article_subcategories").to route_to("article_subcategories#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/article_subcategories/1").to route_to("article_subcategories#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/article_subcategories/1").to route_to("article_subcategories#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/article_subcategories/1").to route_to("article_subcategories#destroy", :id => "1")
    end
  end
end
