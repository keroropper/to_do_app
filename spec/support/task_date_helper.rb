module TaskDateHelper
  def past_task_date(n)
    "#{ I18n.l(Date.current.days_ago(n), format: '%Y-%-m-%-d' )}"
  end

  def dairy_task_date 
    I18n.l(Date.today, format: "%-m月%-d日(%a)")
  end
end

RSpec.configure do |config|
  config.include TaskDateHelper
end