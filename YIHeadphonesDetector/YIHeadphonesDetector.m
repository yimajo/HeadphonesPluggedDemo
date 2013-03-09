//
//  YIHeadphonesDetector.m
//  HeadphonesPluggedDemo
//
//  Created by yimajo on 2013/03/09.
//  Copyright (c) 2013年 yimajo. All rights reserved.
//

#import "YIHeadphonesDetector.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation YIHeadphonesDetector

- (void)dealloc
{
	AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListenerCallback2, (__bridge void *)self);
}

- (id)init
{
	if (self = [super init]) {
		AudioSessionInitialize(NULL, NULL, NULL, NULL);
		AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListenerCallback2, (__bridge void *)self);
	}
	return self;
}

void audioRouteChangeListenerCallback2(void *inUserData,
									   AudioSessionPropertyID inPropertyID,
									   UInt32 inPropertyValueSize,
									   const void *inPropertyValue)
{
	CFDictionaryRef routeChangeDictionary = inPropertyValue;
	CFNumberRef routeChangeReasonRef = CFDictionaryGetValue (routeChangeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
	SInt32 routeChangeReason;
	CFNumberGetValue(routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
	
	if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable
		|| routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable) {
		
		YIHeadphonesDetector *headphonesDetector = (__bridge YIHeadphonesDetector *)inUserData;
		
		if ([headphonesDetector.delegate respondsToSelector: @selector(headphonesDetectorStateChanged:) ]) {
			[headphonesDetector.delegate headphonesDetectorStateChanged:headphonesDetector];
		}
	}
}

- (BOOL)headphonesArePlugged
{
	BOOL result = NO;
	CFStringRef route;
	UInt32 propertySize = sizeof(CFStringRef);

	if (AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route) == 0)	{
		//transferにしてrouteをrelease
		NSString *routeString = (__bridge_transfer NSString *)route;
		
		if ([routeString isEqualToString:@"Headphone"] == YES) {
			result = YES;
		}
	}
	return result;
}


@end
