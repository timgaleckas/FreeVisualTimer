class CentroMainViewController < UIViewController
  attr_accessor :flipsidePopoverController
  attr_accessor :duration
  attr_accessor :start_button, :reset_button, :settings_button
  attr_accessor :time_last_checked, :time_left, :started

  def loadView
    @alarm_sound   ||= load_caf('alarm-clock-1')
    @ticking_sound ||= load_caf('clock-ticking-1')
    @crank_sound   ||= load_caf('crank-2')
    self.duration  ||= 60
    self.started     = !!self.started
    self.time_left ||= self.duration

    self.navigationController.setNavigationBarHidden(true, animated:false)
    self.view = NSBundle.mainBundle.loadNibNamed("FreeVisualTimer-iPad", owner:self, options:nil)[0]

    self.settings_button = self.view.subviews[0].subviews.last
    self.start_button, self.reset_button = view.subviews[-2,2]

    self.settings_button.when(UIControlEventTouchUpInside) do
      unless self.flipsidePopoverController
        self.flipsidePopoverController = UIPopoverController.alloc.initWithContentViewController(CentroFlipsideViewController.alloc.init)
        self.flipsidePopoverController.delegate = self
        self.flipsidePopoverController.contentViewController.delegate = self
        self.flipsidePopoverController.contentViewController.countdown_picker.countDownDuration = self.duration
        self.flipsidePopoverController.presentPopoverFromRect(self.settings_button.frame, inView:self.view, permittedArrowDirections:0, animated:true)
      end
    end
    self.start_button.when(UIControlEventTouchUpInside) do
      if self.started
        self.started = false
        self.time_last_checked = nil
        @ticking_sound.stop
        @timer.invalidate
        @timer = nil
        self.start_button.setTitle('Start',forState:0)
      else
        @timer = NSTimer.scheduledTimerWithTimeInterval(0.03, target:self, selector:'update_pie_view', userInfo:nil, repeats:true)
        self.started = true
        self.time_last_checked = Time.now
        self.start_button.setTitle('Stop',forState:0)
      end
    end
    self.reset_button.when(UIControlEventTouchUpInside) do
      @crank_sound.play
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
    update_pie_view
  end

  def dismiss_popover
    if self.flipsidePopoverController
      self.flipsidePopoverController.dismissPopoverAnimated(true)
      self.flipsidePopoverController = nil
    end
  end

  def popoverControllerDidDismissPopover( popoverController )
    self.flipsidePopoverController = nil
  end

  def timer_pie_chart_view
    @pie_chart_view ||= view.subviews.detect{|v|v.is_a? PieChartView}
  end

  private

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

end
