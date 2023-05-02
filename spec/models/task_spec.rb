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

    describe '#created_at_values' do
      it 'タスクが存在する日付を取得できること' do
        user = create(:user)
        create_list(:task, 3, user: user)
        create(:task, user: user, created_at: '2023-1-1 12:00:00')
        create(:task, user: user, created_at: '2023-1-2 12:00:00')
        create(:task, user: user, created_at: '2023-1-2 13:00:00')
        create(:task, user: user, created_at: '2023-1-3 12:00:00')
        create(:task, user: user, created_at: '2023-1-3 13:00:00')
        results = user.tasks.created_at_values
        expect(results.length).to eq(3)
        expect(results).to match_array(['2023-1-1', '2023-1-2', '2023-1-3']) 
      end
    end

    describe '#task_title_count' do
      it '保存されているtitle属性を多い順に５件取得できること', focus:true do
        create(:task, title: '6番', user: user, created_at: 1.days.ago)
        %w[1 2 3 4 5].each do |n|
          create_list(:task, 2, title: "#{n}番", user: user)
        end
        results = user.tasks.task_title_count.map(&:title)
        expect(results).to match_array(["1番", "2番", "3番", "4番", "5番"])
      end
    end
  end

end
