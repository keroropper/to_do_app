require 'rails_helper'

RSpec.describe "SignUps", type: :system do

  scenario "ユーザーはサインアップに成功する" do
    expect{
      sign_up_user("tester", "test1@example.com", "password")
    }.to change(User, :count).by(1)
    expect(page).to have_content "アカウント登録が完了しました"
    expect(current_path).to  eq root_path
  end

  scenario "nameが空白だとサインアップできないこと" do
    expect{
      sign_up_user("", "test1@example.com", "password")
    }.to_not change(User, :count)
    expect(page).to have_content "名前を入力してください"
    expect(current_path).to  eq signup_path
  end

  scenario "emailが空白だとサインアップできないこと" do
    expect{
      sign_up_user("tester", "", "password")
    }.to_not change(User, :count)
    expect(page).to have_content "メールアドレスを入力してください"
    expect(current_path).to  eq signup_path
  end

  scenario "パスワードと、パスワード（確認用）の値が違うとサインアップできないこと" do

    expect{
      sign_up_user("tester", "test@example.com", "password", "invalid")
    }.to_not change(User, :count)

    expect(page).to have_content "パスワード（確認用）とパスワードの入力が一致しません"
    expect(current_path).to  eq signup_path
  end

  

  def sign_up_user(name, email, password, password_confirmation = password)
    visit root_path
    click_link "アカウント登録"
    fill_in "名前", with: name
    fill_in "メールアドレス", with: email
    fill_in "パスワード", with: password
    fill_in "パスワード（確認用）", with: password_confirmation
    click_button "登録"
  end
  
end
