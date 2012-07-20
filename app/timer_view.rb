class TimerView < PieChartView
  def update(duration, time_left)
    pie_items[0] ||= PieChartItem.new(1,white)
    pie_items[1] ||= PieChartItem.new(1,red)
    pie_items[0].value = duration - time_left
    pie_items[1].value = time_left
    setNeedsDisplay
  end
  def white; PieChartItemColor.new(1.0, 1.0, 1.0, 1.0); end
  def red;   PieChartItemColor.new(1.0, 0.0, 0.0, 1.0); end
end
