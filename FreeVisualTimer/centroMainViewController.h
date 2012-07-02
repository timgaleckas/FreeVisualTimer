//
//  centroMainViewController.h
//  FreeVisualTimer
//
//  Created by Tim Galeckas on 6/29/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "CentroFlipsideViewController.h"
#import "PieChartView.h"

@interface CentroMainViewController : UIViewController <CentroFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@property (weak, nonatomic) IBOutlet PieChartView *timerPieChartView;
- (IBAction)start_stop_tapped:(id)sender;
- (IBAction)reset_tapped:(id)sender;

@end