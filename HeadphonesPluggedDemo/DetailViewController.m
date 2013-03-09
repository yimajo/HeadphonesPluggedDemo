//
//  DetailViewController.m
//  HeadphonesPluggedDemo
//
//  Created by yimajo on 2013/03/09.
//  Copyright (c) 2013年 yimajo. All rights reserved.
//

#import "DetailViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

	if (self.detailItem) {
	    self.detailDescriptionLabel.text = [self.detailItem description];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self configureView];
	
	[HeadphonesDetector sharedDetector].delegate = self;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)headphonesDetectorStateChanged:(HeadphonesDetector *)headphonesDetector
{
	NSString *message = nil;
	if (headphonesDetector.headphonesArePlugged) {
		message = @"plugged";
	} else {
		message = @"unplugged";
	}	
	self.detailDescriptionLabel.text = message;
}

@end
