//
//  DetailViewController.h
//  HeadphonesPluggedDemo
//
//  Created by yimajo on 2013/03/09.
//  Copyright (c) 2013年 yimajo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadphonesDetector.h"

@interface DetailViewController : UIViewController
<HeadphonesDetectorDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
