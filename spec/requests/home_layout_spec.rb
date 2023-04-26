require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /home" do

    it '正常なレスポンスを返すこと' do
      get root_path
      expect(response).to be_successful  
      expect(response).to have_http_status "200"  
    end

    context "ログイン状態"  do
      let(:user) { FactoryBot.create(:user) }
      before do
        sign_in user
        get root_path
      end
      it "ヘッダーに正しいリンクが表示されていること" do
        aggregate_failures do
          expect(response.body).to match(/<a .*>フォロー<\/a>/)
          expect(response.body).to match(/<a .*>フォロワー<\/a>/)
          expect(response.body).to match(/<a .*>プロフィール<\/a>/)
          expect(response.body).to match(/<a .*>公開タスク<\/a>/)
          expect(response.body).to match(/<a .*>ログアウト<\/a>/)
        end
      end
      it "ヘッダーにアカウント登録リンクとログインリンクが表示されていないこと" do
        expect(response.body).to_not match(/<a .*>アカウント登録<\/a>/)
        expect(response.body).to_not match(/<a .*>ログイン<\/a>/)
      end
    end

    context "未ログイン状態" do
      before do
        get root_path
      end

      it "ヘッダーにアカウント登録リンクとログインリンクが表示されていること" do
        expect(response.body).to match(/<a .*>アカウント登録<\/a>/)
        expect(response.body).to match(/<a .*>ログイン<\/a>/)
      end
      it "ヘッダーにログイン済みの場合のリンクが表示されていないこと" do
        aggregate_failures do
          expect(response.body).to_not match(/<a .*>フォロー<\/a>/)
          expect(response.body).to_not match(/<a .*>フォロワー<\/a>/)
          expect(response.body).to_not match(/<a .*>プロフィール<\/a>/)
          expect(response.body).to_not match(/<a .*>公開タスク<\/a>/)
          expect(response.body).to_not match(/<a .*>ログアウト<\/a>/)
        end
      end
    end
    
  end

  describe "Get /signup" do

    it 'ヘッダーが表示されていないこと' do
      get signup_path
      expect(response.body).to_not include("<header>")
    end
  end

  describe "Get /login" do

    it 'ヘッダーが表示されていないこと' do
      get login_path
      expect(response.body).to_not include("<header>")
    end
  end
end
