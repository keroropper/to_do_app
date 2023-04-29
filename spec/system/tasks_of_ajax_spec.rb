require 'rails_helper'

RSpec.describe "TasksOfAjax", type: :system, js: true do

  let!(:user) { create(:user) }
  let!(:task) { create(:task, user: user) }
  before do
    sign_in user
  end

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
    expect(page).to_not have_content task.title
  end

  def create_task(title)
    visit root_path
    fill_in 'タスクを記入', with: title
    click_button '追加 ＋'
  end

  def click_edit_link(task)
    visit root_path
    click_link('', href: "/tasks/#{task.id}/edit")
  end
end
