//Copyright 2011 Igor Kulagin. All rights reserved.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

#import "HeadphonesDetector.h"
#import "AudioToolbox/AudioToolbox.h"

static HeadphonesDetector *headphonesDetector;

@implementation HeadphonesDetector

void audioRouteChangeListenerCallback (void *inUserData, AudioSessionPropertyID inPropertyID, 
									   UInt32 inPropertyValueSize, const void *inPropertyValue);

@synthesize delegate;
@dynamic headphonesArePlugged;


+ (HeadphonesDetector *) sharedDetector {
	if (headphonesDetector == nil) {
		headphonesDetector = [ [self alloc] init];
	}
	return headphonesDetector;
}

- (BOOL) headphonesArePlugged {
	BOOL result = NO;
	CFStringRef route;
	UInt32 propertySize = sizeof(CFStringRef);
	if (AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route) == 0)	{
		NSString *routeString = (NSString *) route;
		if ([routeString isEqualToString: @"Headphone"] == YES) {
			result = YES;
		}
	}
	return result;
}

- (id) init {
	if (self = [super init]) {
		AudioSessionInitialize(NULL, NULL, NULL, NULL);
		AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListenerCallback, self);
		
		return self;
	}
	return nil;
}

- (void) dealloc {
	self.delegate = nil;
	
	[super dealloc];
}

void audioRouteChangeListenerCallback (void *inUserData, AudioSessionPropertyID inPropertyID, 
									   UInt32 inPropertyValueSize, const void *inPropertyValue) {
	CFDictionaryRef routeChangeDictionary = inPropertyValue;
	CFNumberRef routeChangeReasonRef = CFDictionaryGetValue (routeChangeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
	SInt32 routeChangeReason;
	CFNumberGetValue(routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
	
	if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable ||
		routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable) {
		HeadphonesDetector *headphonesDetector = (HeadphonesDetector *) inUserData;
		if ([headphonesDetector.delegate respondsToSelector: @selector(headphonesDetectorStateChanged:) ]) {
			[headphonesDetector.delegate headphonesDetectorStateChanged: headphonesDetector];
		}
	}
}

@end