require 'rails_helper'

RSpec.describe "Tasks", type: :request do

  context 'ログイン済みユーザーとして' do
    let(:user) { create(:user) }
    let!(:task) { create(:task, user: user) }
    let(:task_params) { FactoryBot.attributes_for(:task) }
    before do
      sign_in user
    end
    
    context '有効な属性の場合' do
      it 'タスクを追加できること' do
        # task_params = FactoryBot.attributes_for(:task)
        expect {
          post tasks_path, params: { task: task_params }
        }.to change(Task, :count).by(1)
      end
    end

    context 'titleが空の場合' do
      it 'タスクを追加できないこと' do
        task_params[:title] = ''
        expect {
          post tasks_path, params: { task: task_params }
        }.to_not change(Task, :count)
        expect(response.body).to include 'タスクを入力してください'
      end
    end

    context 'titleが21文字以上の場合' do
      it 'タスクを追加できないこと' do
        task_params[:title] = 'a' * 21
        expect {
          post tasks_path, params: { task: task_params }
        }.to_not change(Task, :count)
        expect(response.body).to include 'タスクは20文字以内で入力してください'
      end
    end

    context 'すでにタスクを10個追加済みの時' do
      it 'タスクを追加できないこと' do
        9.times { create(:task, user: user) }
        expect {
          post tasks_path, params: { task: task_params }
        }.to_not change(Task, :count)
        expect(response.body).to include '１日に追加できるタスクは10個までです'
      end
    end

    context 'すでにタスクを10個追加済みの時/titleが21文字以上の場合' do
      it 'タスクを追加できないこと' do
        9.times { create(:task, user: user) }
        task_params[:title] = 'a' * 21
        expect {
          post tasks_path, params: { task: task_params }
        }.to_not change(Task, :count)
        expect(response.body).to include '１日に追加できるタスクは10個までです'
        expect(response.body).to include 'タスクは20文字以内で入力してください'
      end
    end

    it 'タスクを削除すること' do
      expect {
        delete task_path(task.id)
      }.to change(Task, :count).by(-1)
    end

  end

  context '未ログインユーザーとして' do
    let!(:user) { create(:user) }
    it 'タスクを追加できないこと' do
      task_params = FactoryBot.attributes_for(:task)
      expect {
        post tasks_path, params: { task: task_params }
      }.to_not change(Task, :count)
    end
  end
  

end
