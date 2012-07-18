class CentroFlipsideViewController < UIViewController
  attr_accessor :delegate

  def loadView
    self.view = NSBundle.mainBundle.loadNibNamed("FreeVisualTimer-iPad", owner:self, options:nil)[1]
    self.view.subviews[0].subviews.last.when(UIControlEventTouchUpInside) do
      self.delegate.dismiss_popover
    end
    countdown_picker.addTarget(self, action:'duration_did_change', forControlEvents:UIControlEventValueChanged)
  end

  def duration_did_change(*picker)
    self.delegate.duration_did_change(picker.countDownDuration)
  end

  def countdown_picker
    self.view.subviews[1]
  end
end
