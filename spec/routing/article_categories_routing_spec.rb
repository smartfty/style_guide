require "rails_helper"

RSpec.describe ArticleCategoriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/article_categories").to route_to("article_categories#index")
    end

    it "routes to #new" do
      expect(:get => "/article_categories/new").to route_to("article_categories#new")
    end

    it "routes to #show" do
      expect(:get => "/article_categories/1").to route_to("article_categories#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/article_categories/1/edit").to route_to("article_categories#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/article_categories").to route_to("article_categories#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/article_categories/1").to route_to("article_categories#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/article_categories/1").to route_to("article_categories#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/article_categories/1").to route_to("article_categories#destroy", :id => "1")
    end
  end
end
