//
//  DetailViewController.h
//  HeadphonesPluggedDemo
//
//  Created by yimajo on 2013/03/09.
//  Copyright (c) 2013年 yimajo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YIHeadphonesDetector.h"

@interface DetailViewController : UIViewController
<YIHeadphonesDetectorDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
