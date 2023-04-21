require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /home" do

    it '正常なレスポンスを返すこと' do
      get root_path
      expect(response).to be_successful  
      expect(response).to have_http_status "200"  
    end
  end

  describe "Get /signup" do

    it 'ヘッダーが表示されていないこと' do
      get signup_path
      expect(response.body).to_not include("<header>")
    end
  end

  describe "Get /login", focus: true do

    it 'ヘッダーが表示されていないこと' do
      get login_path
      expect(response.body).to_not include("<header>")
    end
  end
end
