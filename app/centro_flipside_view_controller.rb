class CentroFlipsideViewController < UIPopoverController
  attr :delegate

  def done(id)
    self.delegate.flipsideViewControllerDidFinish(self)
  end

end
