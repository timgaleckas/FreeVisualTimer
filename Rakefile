# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bubble-wrap'
require 'rubygems'
require 'motion-testflight'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'FreeVisualTimer'
  app.device_family = [:ipad, :iphone]
  app.info_plist['UIMainStoryboardFile'] = 'MainStoryboard'
  app.frameworks << 'OpenGLES'
  app.frameworks << 'QuartzCore'
  app.frameworks << 'GLKit'
  app.frameworks << 'AVFoundation'

  #TestFlight stuff
  app.testflight.sdk = 'vendor/TestFlight'
  app.testflight.api_token = 'af99c949920dbe0260ddbd620ecf4282_Mzc0MTc2MjAxMi0wMy0yNyAyMTowNjo0NS4yMDQxNTk'
  app.testflight.team_token = 'a76d6d9c00b59b21be662cb7bec366a2_NzI5MjUyMDEyLTAzLTE5IDE0OjM4OjUxLjgyNTQwMg'
  app.testflight.distribution_lists = ['20PctTeam']
end
