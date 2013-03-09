//
//  YIHeadphonesDetector.h
//  HeadphonesPluggedDemo
//
//  Created by yimajo on 2013/03/09.
//  Copyright (c) 2013年 yimajo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YIHeadphonesDetector;

@protocol YIHeadphonesDetectorDelegate <NSObject>

- (void) headphonesDetectorStateChanged: (YIHeadphonesDetector *) headphonesDetector;

@end

@interface YIHeadphonesDetector : NSObject

@property (weak, nonatomic) id<YIHeadphonesDetectorDelegate> delegate;

- (BOOL)headphonesArePlugged;

@end
