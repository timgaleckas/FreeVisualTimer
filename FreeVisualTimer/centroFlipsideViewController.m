//
//  centroFlipsideViewController.m
//  FreeVisualTimer
//
//  Created by Tim Galeckas on 6/29/12.
//  Copyright (c) 2012 none. All rights reserved.
//

#import "CentroFlipsideViewController.h"

@interface CentroFlipsideViewController ()

@end

@implementation CentroFlipsideViewController

@synthesize delegate = _delegate;
@synthesize countdownPickerView = _countdownPickerView;

- (void)awakeFromNib
{
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setCountdownPickerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)timerValueDidChange:(id)sender {
}

@end
