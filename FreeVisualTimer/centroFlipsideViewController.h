//
//  centroFlipsideViewController.h
//  FreeVisualTimer
//
//  Created by Tim Galeckas on 6/29/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CentroFlipsideViewController;

@protocol CentroFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(CentroFlipsideViewController *)controller;
@end

@interface CentroFlipsideViewController : UIViewController

@property (weak, nonatomic) id <CentroFlipsideViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIDatePicker *countdownPickerView;

@end
