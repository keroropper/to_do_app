require 'rails_helper'

RSpec.describe "SignUps", type: :system do

  scenario "ユーザーはサインアップに成功する" do
    visit root_path
    click_link "アカウント登録"
    save_and_open_page
    expect{
      fill_in "名前", with: "name"
      fill_in "Eメール", with: "test@example.com"
      fill_in "パスワード", with: "password"
      fill_in "パスワード（確認用）", with: "password"
      click_button "登録"
    }.to change(User, :count).by(1)
    expect(current_path).to  eq root_path
  end
  
end
