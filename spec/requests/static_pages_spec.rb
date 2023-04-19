require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /home" do

    it '正常なレスポンスを返すこと' do
      get root_path
      expect(response).to be_successful  
      expect(response).to have_http_status "200"  
    end
  end
end
