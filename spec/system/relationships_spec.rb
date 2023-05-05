require 'rails_helper'

RSpec.describe "Relationships", type: :system do
  let!(:user) { FactoryBot.send(:create_relationships) }
  let!(:other) { FactoryBot.create(:user, name: '他のユーザー') }
  before do
    sign_in user
  end

  it 'ユーザー詳細ページでfollowingとfollowersが正しく表示されること' do
    visit user_path(user)
    expect(page).to have_content 'フォロワー3人'
    expect(page).to have_content 'フォロー中3人'
  end

  it 'フォローページにフォローしているユーザーが表示されていること' do
    visit following_user_path(user)
    expect(page).to_not have_content '他のユーザー'
    user.follow(other)
    visit following_user_path(user)
    expect(page).to have_content '他のユーザー'
  end

  describe '#Ajax', js: true do

    scenario 'ユーザーは他のユーザーをフォローする' do
      visit user_path(other)
      expect(page).to have_button('フォローする')
      expect(page).to have_content('フォロワー0人')
      expect {
        click_button 'フォローする'
        sleep 1
      }.to change(user.followings, :count).by(1).and change(other.followers, :count).by(1)
      expect(page).to have_button('フォロー解除')
      expect(page).to have_content('フォロワー1人')
    end

    scenario 'ユーザーは他のユーザーのフォローを解除する' do
      user.follow(other)
      visit user_path(other)
      expect(page).to have_button('フォロー解除')
      expect(page).to have_content('フォロワー1人')
      expect {
        click_button 'フォロー解除'
        sleep 1
      }.to change(user.followings, :count).by(-1).and change(other.followers, :count).by(-1)
      expect(page).to have_button('フォローする')
      expect(page).to have_content('フォロワー0人')
    end

  end


end
