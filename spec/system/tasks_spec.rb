require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  
  let!(:user) { create(:user) }
  let!(:task) { create(:task, user: user) }
  before do
    sign_in user
  end
  before do
    Rails.cache.clear
  end
  
  describe "Get/home" do  
    it '今日の日付が表示されていること' do
      visit root_path
      expect(page).to have_content "#{I18n.l(Date.today, format: "%-m月%d日(%a)")}のタスク"
    end
  end

  
  scenario 'ユーザーは新しいタスクを追加する' do
    expect {
      create_task('Test task')
    }.to change(Task, :count).by(1)
    expect(page).to have_content 'Test task'
  end
  
  scenario 'ユーザーは過去のタスクを閲覧する' do
    FactoryBot.create_list(:task, 5, :past_task, user: user)
    visit root_path
    1.upto(5) do |n|
      expect(page).to have_content "#{ I18n.l(Date.current.days_ago(n), format: '%Y-%-m-%-d')}"
    end
    click_link "#{ I18n.l(Date.current.days_ago(1), format: '%Y-%-m-%-d') }"
    expect(page).to have_content '1日前のタスク'
    expect(page).to have_field('completed', disabled: true)
    expect(page).to_not have_selector(".btn.btn-warning")
    expect(page).to_not have_selector(".btn.btn-danger")
  end


  def create_task(title)
    visit root_path
    fill_in '20文字以内で入力', with: title
    click_button '追加 ＋'
  end

end
