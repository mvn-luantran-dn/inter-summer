module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Autions'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def format_time_to_seconds(time)
    time = time.strftime('%H:%M:%S').split(':')
    time[0].to_i * 3600 + time[1].to_i * 60 + time[2].to_i
  end
end
