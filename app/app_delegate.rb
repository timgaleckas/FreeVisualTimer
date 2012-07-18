class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @window.backgroundColor = UIColor.blackColor
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(CentroMainViewController.alloc.init)

    @window.makeKeyAndVisible()

    true
  end
  def setWindow(_window)
    @window=_window
  end
  def window
    @window
  end
  def self.nib
    Device.ipad? ? NSBundle.mainBundle.loadNibNamed("FreeVisualTimer-iPad", owner:self, options:nil) :
                   NSBundle.mainBundle.loadNibNamed("FreeVisualTimer-iPhone", owner:self, options:nil)
  end
end
