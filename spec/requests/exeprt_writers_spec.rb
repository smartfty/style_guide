require 'rails_helper'

RSpec.describe "ExeprtWriters", type: :request do
  describe "GET /exeprt_writers" do
    it "works! (now write some real specs)" do
      get exeprt_writers_path
      expect(response).to have_http_status(200)
    end
  end
end
