class CentroMainViewController < UIViewController
  attr_accessor :flipsidePopoverController
  attr_reader   :duration
  attr_accessor :start_button, :reset_button, :settings_button, :timer_pie_chart_view
  attr_accessor :time_last_checked, :time_left, :started

  def duration=(new_duration)
    @duration=new_duration
    update_pie_view
    @duration
  end

  def ticking_sound
    @ticking_sound ||= load_caf('clock-ticking-1')
  end

  def crank_sound
    @crank_sound   ||= load_caf('crank-2')
  end

  def alarm_sound
    @alarm_sound   ||= load_caf('alarm-clock-1')
  end


  def loadView
    self.duration  ||= 60
    self.started     = !!self.started
    self.time_left ||= self.duration

    self.navigationController.setNavigationBarHidden(true, animated:false)
    self.view = AppDelegate.nib[0]

    self.settings_button = self.view.subviews[0].subviews.last
    self.timer_pie_chart_view, self.start_button, self.reset_button = view.subviews[-3,3]

    self.settings_button.when(UIControlEventTouchUpInside) do
      unless self.flipsidePopoverController
        if Device.ipad?
          self.flipsidePopoverController = UIPopoverController.alloc.initWithContentViewController(CentroFlipsideViewController.alloc.init)
          self.flipsidePopoverController.setPopoverContentSize CGSizeMake(320, 640)
          self.flipsidePopoverController.contentViewController.delegate = self
          self.flipsidePopoverController.contentViewController.countdown_picker.countDownDuration = self.duration
          self.flipsidePopoverController.presentPopoverFromRect(self.settings_button.frame, inView:self.view, permittedArrowDirections:0, animated:true)
        else
          self.flipsidePopoverController = CentroFlipsideViewController.alloc.init
          self.navigationController.pushViewController(self.flipsidePopoverController, animated:true)
          self.flipsidePopoverController.countdown_picker.countDownDuration = self.duration
        end
        self.flipsidePopoverController.delegate = self
      end
    end
    self.start_button.when(UIControlEventTouchUpInside) do
      if self.started
        self.stop!
      else
        self.start!
      end
    end
    self.reset_button.when(UIControlEventTouchUpInside) do
      self.stop!
      self.crank_sound.play
      self.time_last_checked = nil
      self.started = false
      self.time_left = self.duration
      update_pie_view
    end
    if self.started
      @timer = NSTimer.scheduledTimerWithTimeInterval(0.03, target:self, selector:'update_pie_view', userInfo:nil, repeats:true)
    else
      update_pie_view
    end
  end

  def duration_did_change(new_duration)
    self.duration = new_duration
  end

  def dismiss_popover
    if self.flipsidePopoverController
      if Device.ipad?
        self.flipsidePopoverController.dismissPopoverAnimated(true)
      else
        self.navigationController.popViewControllerAnimated true
      end
      self.flipsidePopoverController = nil
    end
  end

  def popoverControllerDidDismissPopover( popoverController )
    self.flipsidePopoverController = nil
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
    unless self.flipsidePopoverController
      self.timer_pie_chart_view.pie_items[0] ||= PieChartItem.new(1,white)
      self.timer_pie_chart_view.pie_items[1] ||= PieChartItem.new(1,red)
      self.timer_pie_chart_view.pie_items[0].value = self.duration - self.time_left
      self.timer_pie_chart_view.pie_items[1].value = self.time_left
      self.timer_pie_chart_view.setNeedsDisplay
    end
    if self.started
      self.ticking_sound.play if self.ticking_sound.currentTime = 0.0
      if time_left < 0.01
        alarm!
        self.started = false
      end
    end
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

  def start!
    unless self.started
      self.started = true
      self.time_last_checked = Time.now
      @timer = NSTimer.scheduledTimerWithTimeInterval(0.03, target:self, selector:'update_pie_view', userInfo:nil, repeats:true)
      self.start_button.setTitle('Stop',forState:0)
    end
  end

  def stop!
    if self.started
      self.started = false
      self.time_last_checked = nil
      self.ticking_sound.stop
      @timer.invalidate
      @timer = nil
      self.start_button.setTitle('Start',forState:0)
    end
  end

  def alarm!
    self.ticking_sound.stop
    self.alarm_sound.play
    App.alert("Time's up!")
  end

end
