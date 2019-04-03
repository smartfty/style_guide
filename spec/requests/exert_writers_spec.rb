require 'rails_helper'

RSpec.describe "ExertWriters", type: :request do
  describe "GET /exert_writers" do
    it "works! (now write some real specs)" do
      get exert_writers_path
      expect(response).to have_http_status(200)
    end
  end
end
