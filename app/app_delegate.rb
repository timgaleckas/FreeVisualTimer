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
end
