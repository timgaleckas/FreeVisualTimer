class CentroMainViewController < UIViewController
  attr_accessor :flipsidePopoverController
  attr_accessor :duration
  attr_accessor :time_last_checked, :time_left, :started
  attr_accessor :timer_pie_chart_view, :onOffView

  def flipsideViewControllerDidFinish(controller)
    self.flipsidePopoverController.dismissPopoverAnimated(true)
    self.flipsidePopoverController = nil;
    update_pie_view
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
    self.duration ||= 60
    self.started = false if self.started.nil?
    self.time_left = self.duration if self.time_left.nil?
    @alarm_sound ||= load_caf('alarm-clock-1')
    @ticking_sound ||= load_caf('clock-ticking-1')
    @crank_sound ||= load_caf('crank-2')
    if self.started
      @timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:'update_pie_view', userInfo:nil, repeats:true)
    else
      update_pie_view
    end
  end

  def viewDidUnload
    @timer.invalidate
    @timer = nil
    self.timer_pie_chart_view = nil
  end

  def load_caf(name)
    path = NSBundle.mainBundle.pathForResource(name, ofType:'caf')
    url = NSURL.fileURLWithPath(path)
    error_ptr = Pointer.new(:id)
    sound = AVAudioPlayer.alloc.initWithContentsOfURL(url, error:error_ptr)
    raise "Can't open sound file: #{error_ptr[0].description}" unless sound
    sound
  end

  def update_pie_view
    return unless self.timer_pie_chart_view
    update_time_left
    self.timer_pie_chart_view.pie_items[0] ||= PieChartItem.new(1,white)
    self.timer_pie_chart_view.pie_items[1] ||= PieChartItem.new(1,red)
    self.timer_pie_chart_view.pie_items[0].value = self.duration - self.time_left
    self.timer_pie_chart_view.pie_items[1].value = self.time_left
    if self.started
      @ticking_sound.play if @ticking_sound.currentTime = 0.0
      if time_left < 0.01
        alarm!
        self.started = false
      end
    end
    self.timer_pie_chart_view.setNeedsDisplay
  end

  def white; PieChartItemColor.new(1.0, 1.0, 1.0, 1.0); end
  def red;   PieChartItemColor.new(1.0, 0.0, 0.0, 1.0); end

  def update_time_left
    if self.time_last_checked
      now = Time.now
      self.time_left -= (now - self.time_last_checked)
      self.time_last_checked = now
    end
  end

  def seconds_passed
    self.time_last_checked ? (Time.now - self.time_last_checked) : 0
  end

  def alarm!
    @ticking_sound.stop
    @alarm_sound.play
  end

  def timer_pie_chart_view
    @pie_chart_view ||= view.subviews.detect{|v|v.is_a? PieChartView}
  end

  def button_views
    @button_views ||= view.subviews.select{|v|v.is_a? UIRoundedRectButton}
  end

  def start_stop_button_view
    @start_stop_button_view ||= button_views[0]
  end

  def start_stop_tapped(id)
    if self.started
      self.started = false
      self.time_last_checked = nil
      @ticking_sound.stop
      @timer.invalidate
      @timer = nil
      start_stop_button_view.setTitle('Start',forState:0)
    else
      @timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target:self, selector:'update_pie_view', userInfo:nil, repeats:true)
      self.started = true
      self.time_last_checked = Time.now
      start_stop_button_view.setTitle('Stop',forState:0)
    end
  end

  def reset_tapped(id)
    @crank_sound.play
    self.time_last_checked = nil
    self.started = false
    self.time_left = self.duration
    update_pie_view
  end

end
