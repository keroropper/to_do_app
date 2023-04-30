require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { build(:task) }
  it 'title属性がないと許可しないこと' do
    task.title = ""
    task.valid?
    expect(task).to_not be_valid
  end

  it 'title属性が21文字以上だと許可しないこと' do
    task.title = "a" * 26
    task.valid?
    expect(task).to_not be_valid
  end
  
  describe '#validate_daily_task_limit' do

    let(:user) { create(:user) }
    let(:task) { user.tasks.build(title: 'test', completed: false, created_at: Date.today) }
    
    context "ユーザーがすでに10個のタスクを持っている場合" do
      before do
        10.times { create(:task, user: user) }
      end
      
      it 'task.errors[:base]にメッセージが追加されること' do
        task.save
        expect(task.errors[:base]).to include('１日に追加できるタスクは10個までです') 
      end
    end

    context "ユーザーのタスクが10個未満の場合" do

      before do
        5.times { create(:task, user: user) }
      end

      it 'task.errors[:base]の値が空であること' do
        task.save
        expect(task.errors[:base]).to be_empty
      end
    end
  end

end
