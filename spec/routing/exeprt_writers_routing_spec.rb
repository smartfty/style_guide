require "rails_helper"

RSpec.describe ExeprtWritersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/exeprt_writers").to route_to("exeprt_writers#index")
    end

    it "routes to #new" do
      expect(:get => "/exeprt_writers/new").to route_to("exeprt_writers#new")
    end

    it "routes to #show" do
      expect(:get => "/exeprt_writers/1").to route_to("exeprt_writers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/exeprt_writers/1/edit").to route_to("exeprt_writers#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/exeprt_writers").to route_to("exeprt_writers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/exeprt_writers/1").to route_to("exeprt_writers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/exeprt_writers/1").to route_to("exeprt_writers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/exeprt_writers/1").to route_to("exeprt_writers#destroy", :id => "1")
    end
  end
end
