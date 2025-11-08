require 'rails_helper'

RSpec.describe SearchsController, type: :controller do

  describe "GET #universalSearch" do
    it "returns http success" do
      get :universalSearch
      expect(response).to have_http_status(:success)
    end
  end

end
