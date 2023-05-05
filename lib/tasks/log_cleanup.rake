# タスクの説明
desc 'Clean up tmp files'

# タスクの名前を定義。このタスクがRailsの環境を使用することを指定
task tmp_cleanup: :environment do
  require 'fileutils'
  # 'log'というディレクトリを指定
  tmp_path = Rails.root.join('tmp')
  miniprofiler_path = tmp_path.join('miniprofiler')
  screenshots_path = tmp_path.join('screenshots')
  FileUtils.rm_rf(miniprofiler_path)
  FileUtils.rm_rf(screenshots_path)
end