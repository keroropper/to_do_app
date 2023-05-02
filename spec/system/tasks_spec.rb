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
      expect(page).to have_content "#{I18n.l(Date.today, format: "%-m月%-d日(%a)")}のタスク"
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

  scenario '他のユーザーの過去のタスクは表示されていないこと' do
    other_user = create(:user)
    other_user_task = create(:task, :past_task, user: other_user)
    visit root_path
    expect(page).to_not have_content "#{ I18n.l(Date.current.days_ago(1), format: '%Y-%-m-%-d')}"
  end

  scenario 'サイドバーの、使用頻度の高いタスク一覧からタスクを追加できること' do
    create(:task, title: 'いっぱい使う', user: user )
    visit root_path
    many_use_task = find("ul.display-title li.task-title", text: 'いっぱい使う')
    expect(page).to have_css("ul.display-title li.task-title", text: 'いっぱい使う')
    many_use_task.click
    expect(page).to have_content('いっぱい使う', count: 2)
  end

  scenario '他のユーザーの、使用頻度が高いタスクは表示されていないこと' do
    other_user = create(:user)
    create(:task, title: '他のタスク', user: other_user )
    visit root_path
    expect(page).to_not have_css("ul.display-title li.task-title", text: '他のタスク')
  end

  def create_task(title)
    visit root_path
    fill_in '20文字以内で入力', with: title
    click_button '追加 ＋'
  end

end
