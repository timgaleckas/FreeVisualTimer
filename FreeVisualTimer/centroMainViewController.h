//
//  centroMainViewController.h
//  FreeVisualTimer
//
//  Created by Tim Galeckas on 6/29/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "CentroFlipsideViewController.h"

@interface CentroMainViewController : UIViewController <centroFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
