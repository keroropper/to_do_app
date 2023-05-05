require 'rails_helper'

RSpec.describe "Users", type: :system do
  
  describe '#show' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    before do
      sign_in user 
      create_list(:task, 3, :past_task, user: other)
    end
    scenario 'ユーザー詳細ページから、そのユーザーのタスク履歴にアクセスすること'  do
      visit user_path(other)
      within all('.tasks-history').first do
        click_link "#{ I18n.l(Date.current.days_ago(1), format: '%Y-%-m-%-d')}"
      end
      expect(page).to have_content('1日前のタスク')
      expect(page).to have_content("#{ I18n.l(Date.current.days_ago(1), format: '%-m月%-d日(%a)のタスク')}")
    end

    scenario '自分のプロフィール画像をクリックすると編集ポップアップが表示される' do
      visit user_path(user)
      find('.my_image').click
      expect(page).to have_selector('.popup-menu')
      expect(page).to have_content('プロフィール写真を変更')
      expect(page).to have_content('写真をアップロード')
      expect(page).to_not have_content('現在の写真を削除')
      expect(page).to have_content('キャンセル')
    end
    scenario '他人のプロフィール画像をクリックしても編集ポップアップは表示されない' do
      visit user_path(other)
      find('.profile-image').click
      expect(page).to_not have_selector('.popup-menu')
    end

  end

end
