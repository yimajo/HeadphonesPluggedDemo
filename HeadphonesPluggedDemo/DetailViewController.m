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

@property (strong, nonatomic) YIHeadphonesDetector *headphoneDetector;

- (void)configureView;

@end

@implementation DetailViewController

- (void)dealloc
{
	NSLog(@"DetailViewController dealloc");
}

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
	
	self.headphoneDetector = [[YIHeadphonesDetector alloc] init];
	self.headphoneDetector.delegate = self;
	[self.headphoneDetector headphonesArePlugged];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)headphonesDetectorStateChanged:(YIHeadphonesDetector *)headphonesDetector
{
	[self assignStateWithHeadphonesArePlugged:headphonesDetector.headphonesArePlugged];
}

- (void)assignStateWithHeadphonesArePlugged:(BOOL)headphonesPlugged
{
	NSString *message = nil;
	if (headphonesPlugged) {
		message = @"plugged";
	} else {
		message = @"unplugged";
	}
	self.detailDescriptionLabel.text = message;
}

@end
