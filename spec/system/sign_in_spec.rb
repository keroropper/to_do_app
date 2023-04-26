require 'rails_helper'

RSpec.describe "SignIns", type: :system do

  let(:user) { FactoryBot.create(:user) }

  scenario 'ユーザーはログインに成功する' do
    log_in_user(user.email, user.password)
    expect(current_path).to eq root_path
    expect(page).to have_content "ログインしました"
    expect(current_path).to  eq root_path
  end

  scenario 'メールアドレスが誤っている場合、ログインに失敗する' do
    log_in_user('wrong_email@example.com', user.password)
    expect(current_path).to eq login_path
    expect(page).to have_content 'メールアドレスまたはパスワードが違います'
  end

  scenario 'パスワードが誤っている場合、ログインに失敗する' do
    log_in_user(user.email, 'wrong_password')
    expect(current_path).to eq login_path
    expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
  end

  def log_in_user(email, password)
    visit root_path
    click_link "ログイン"
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_button 'ログイン'
  end
end

