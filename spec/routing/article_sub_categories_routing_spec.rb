require "rails_helper"

RSpec.describe ArticleSubCategoriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/article_sub_categories").to route_to("article_sub_categories#index")
    end

    it "routes to #new" do
      expect(:get => "/article_sub_categories/new").to route_to("article_sub_categories#new")
    end

    it "routes to #show" do
      expect(:get => "/article_sub_categories/1").to route_to("article_sub_categories#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/article_sub_categories/1/edit").to route_to("article_sub_categories#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/article_sub_categories").to route_to("article_sub_categories#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/article_sub_categories/1").to route_to("article_sub_categories#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/article_sub_categories/1").to route_to("article_sub_categories#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/article_sub_categories/1").to route_to("article_sub_categories#destroy", :id => "1")
    end
  end
end
