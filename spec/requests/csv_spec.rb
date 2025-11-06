require 'rails_helper'

RSpec.describe "Csvs", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/csv/create"
      expect(response).to have_http_status(:success)
    end
  end

end
