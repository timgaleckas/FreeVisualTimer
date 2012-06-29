//
//  centroFlipsideViewController.h
//  FreeVisualTimer
//
//  Created by Tim Galeckas on 6/29/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@class centroFlipsideViewController;

@protocol centroFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(centroFlipsideViewController *)controller;
@end

@interface centroFlipsideViewController : UIViewController

@property (weak, nonatomic) id <centroFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
