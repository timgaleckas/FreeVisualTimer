class CentroMainViewController < UIViewController
  attr_accessor :flipsidePopoverController

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
      popoverController = segue.popoverController
      puts popoverController.inspect
      puts popoverController.class.inspect
      popoverController.delegate = self
      self.flipsidePopoverController = popoverController
    end
  end

  def togglePopover(sender)
    if self.flipsidePopoverController
      self.flipsidePopoverController.dismissPopoverAnimated(true)
      self.flipsidePopoverController = nil
    else
      self.performSegueWithIdentifier("showAlternate", sender:sender);
    end
  end

end
