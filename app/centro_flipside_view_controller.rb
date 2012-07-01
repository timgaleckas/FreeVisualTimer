class CentroFlipsideViewController < UIViewController
  attr_accessor :delegate
  attr_accessor :countdownPickerView

  def timerValueDidChange(id)
    self.delegate.duration = countdownPickerView.countDownDuration
  end

  def setCountdownPickerView(pickerView)
    self.countdownPickerView = pickerView
  end

  def done(id)
    self.delegate.flipsideViewControllerDidFinish(self)
  end

end
