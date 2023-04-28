# タスクの説明
desc 'Clean up lod log files'

# タスクの名前を定義。このタスクがRailsの環境を使用することを指定
task log_cleanup: :environment do
  # 'log'というディレクトリを指定
  logs_dir = Rails.root.join('log')
  # ログファイルの検索
  Dir.glob(logs_dir.join('*.log')).each do |log_file|
      File.delete(log_file)
      Rails.logger.info "Deleted old log file: #{log_file}"
  end
end