class CentroMainViewController < UIViewController
  attr_accessor :flipsidePopoverController
  attr_accessor :duration
  attr_accessor :timerPieChartView

  def flipsideViewControllerDidFinish(controller)
    self.flipsidePopoverController.dismissPopoverAnimated(true)
    self.flipsidePopoverController = nil;
  end

  def popoverControllerDidDismissPopover(popover_controller)
    self.flipsidePopoverController = nil;
  end

  def prepareForSegue(segue, sender:sender)
    super
    if segue.identifier == "showAlternate"
      segue.destinationViewController.delegate = self
      popoverController = segue.popoverController
      popoverController.delegate = self
      self.flipsidePopoverController = popoverController
    end
  end

  def togglePopover(sender)
    if self.flipsidePopoverController
      self.flipsidePopoverController.dismissPopoverAnimated(true)
      self.flipsidePopoverController = nil
    else
      self.performSegueWithIdentifier("showAlternate", sender:sender)
    end
  end

  def viewDidLoad
    super
    view.addSubview( timerPieChartView )
  end

  def viewDidUnload
    self.timerPieChartView = nil
  end

  def hello
  end

end
