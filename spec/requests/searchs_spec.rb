require 'rails_helper'

RSpec.describe "Searchs", type: :request do
  describe "GET /universalSearch" do
    it "returns http success" do
      get "/searchs/universalSearch"
      expect(response).to have_http_status(:success)
    end
  end

end
