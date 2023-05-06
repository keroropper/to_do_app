require 'rails_helper'

RSpec.describe "Users", type: :request do

  context 'ログインユーザーとして' do
    let!(:user) { create(:user) }
    let(:other) { create(:user, name: '他のユーザー') }
    before do
      sign_in user
      create(:task, :past_task, user: other)
    end
    
    describe '#create' do
      it 'ユーザーを作成するとデフォルトの画像がアタッチされていること' do
        expect(user.image.attached?).to be_truthy
        expect(user.image.filename.to_s).to eq 'default.png'
      end
    end

    describe '#show' do
      subject(:image_attach) do 
        image = Rails.root.join('spec', 'images', 'sample_image.jpg')
        user.image.attach(io: File.open(image), filename: 'sample_image.jpg')
      end

      it 'ユーザーの名前が表示されていること' do
        get user_path(other)
        expect(response.body).to include other.name
      end
      it 'ユーザーがタスクを保持する日時のリンクが表示されていること' do
        get user_path(other)
        expect(response.body).to include(past_task_date(1))
      end
      it 'ユーザーがタスクを追加した日の日数が表示されていること'  do
        get user_path(other)
        expect(response.body).to include "タスク履歴#{other.tasks.created_at_values.length}件"
      end

      it 'ユーザーはプロフィール写真を変更すること' do
        image_attach
        get user_path(user)
        expect(response.body).to match(/sample_image.jpg/)
      end
      
      it 'ユーザーはプロフィール写真を削除すること' do
        image_attach
        delete user_path(user)
        expect(user.reload.image.filename.to_s).to eq 'default.png'
      end
    end

    describe '#index' do
      before do
        3.times do |n|
          create(:user, name: "ユーザー#{n}")
        end
      end

      it '自分以外のユーザーがすべて表示されていること' do
        get users_path
          3.times do |n|
            expect(response.body).to include("ユーザー#{n}")
          end
      end
    end

    describe '#followings' do
      let(:user) { FactoryBot.send(:create_relationships) }
      it 'フォローしているユーザーが表示されること' do
        get following_user_path(user)
        expect(response.body).to include("#{user.followings.count}フォロー")
        user.followings.each do |followed| 
          expect(response.body).to include followed.name
        end
      end
      
      it 'ユーザーのフォロワーが表示されること' do
        get followers_user_path(user)
        expect(response.body).to include("#{user.followers.count}フォロワー")
        user.followers.each do |follower| 
          expect(response.body).to include follower.name
        end
      end
    end
  end

  context '未ログインユーザーとして' do
    let(:user) { create(:user) }
    describe '#show' do
      it 'showページへアクセスしようとするとログインページへ遷移すること' do
        get user_path(user)
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_url
      end
    end
    describe '#index' do
      it 'indexページへアクセスしようとするとログインページへ遷移すること' do
        get users_path
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_url
      end
    end
    describe '#following' do
      it 'followingページへアクセスしようとするとログインページへ遷移すること' do
        get following_user_path(user)
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_url
      end
    end
    describe '#followers' do
      it 'followersページへアクセスしようとするとログインページへ遷移すること' do
        get followers_user_path(user)
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_url
      end
    end
  end

end
