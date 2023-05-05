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

  it '過去のタスクページにユーザーの詳細ページへのリンクが表示されていること', focus: true do
    create(:task, :past_task, user: user)
    visit user_path(user)
    within all('.main-contents').first do
      click_link "#{ I18n.l(Date.current.days_ago(1), format: '%Y-%-m-%-d')}"
    end
    expect(page).to have_content user.name
    expect(page).to have_selector "a[href='/users/#{user.id}']"
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

  describe '#Ajax', js: true do
    scenario 'タスク編集ボタンを押すと、編集用のフィールドが表示されること' do  
      click_edit_link(task)
      expect(page).to have_selector 'input.edit-task-form'
      expect(page).to have_xpath("//input[@value='#{CGI.escapeHTML(task.title)}']")
    end
  
    scenario 'ユーザーはタスクを編集する' do
      click_edit_link(task)
      fill_in 'task[title]', with: 'タスクを編集', class: 'form-control edit-task-form'
      click_button '更新'
      expect(page).to have_content 'タスクを編集'
    end
  
  
    scenario 'タスク編集フォームを入力中に、タスク追加フォームをクリックすると編集フォームが元に戻ること', js: true do
      click_edit_link(task)
      expect(page).to have_selector 'input.edit-task-form'
      find(".add-task-form").click
      expect(page).to_not have_selector 'input.edit-task-form'
    end
  
    scenario 'ユーザーはタスクを完了済み(未完了)にする' do
      visit root_path
      check 'task[completed]'
      wait_for_ajax
      expect(task.reload.completed?).to be true
      uncheck 'task[completed]'
      wait_for_ajax
      expect(task.reload.completed?).to be false
    end
  
    scenario 'ユーザーはタスクを削除する' do
      visit root_path
      click_link('', href: "/tasks/#{task.id}")
      expect(find(".main-contents")).to_not have_content task.title
    end
  end

  def create_task(title)
    visit root_path
    fill_in '20文字以内で入力', with: title
    click_button '追加 ＋'
  end

  def click_edit_link(task)
    visit root_path
    click_link('', href: "/tasks/#{task.id}/edit")
  end

end
