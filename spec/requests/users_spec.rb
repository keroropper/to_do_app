require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe '#create' do
    let!(:user) { create(:user) }
    it 'ユーザーを作成するとデフォルトの画像がアタッチされていること' do
      expect(user.image.attached?).to be_truthy
      expect(user.image.filename.to_s).to eq 'default.png'
    end
  end

  describe '#show' do
    let(:user) { create(:user) }
    let(:other) { create(:user, name: '他のユーザー') }
    before do
      sign_in user
      create(:task, :past_task, user: other)
    end
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
    let(:user) { create(:user) }
    before do
      3.times do |n|
        create(:user, name: "ユーザー#{n}")
      end
      sign_in user
    end

    it '自分以外のユーザーがすべて表示されていること' do
      get users_path
        3.times do |n|
          expect(response.body).to include("ユーザー#{n}")
        end
    end
  end

  describe '#followings' do
    
    it 'フォローしているユーザーが表示されること' do
      user = FactoryBot.send(:create_relationships) 
      sign_in user
      get following_user_path(user)
      expect(response.body).to include("#{user.followings.count}フォロー")
      user.followings.each do |followed| 
        expect(response.body).to include followed.name
      end
    end
    
    it 'ユーザーのフォロワーが表示されること' do
      user = create_relationships
      sign_in user
      get followers_user_path(user)
      expect(response.body).to include("#{user.followers.count}フォロワー")
      user.followers.each do |follower| 
        expect(response.body).to include follower.name
      end
    end


  end

end
