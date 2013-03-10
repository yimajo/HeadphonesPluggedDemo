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
	//プロパティリスナーコールバック関数を削除します
	AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange,
												   audioRouteChangeListenerCallback,
												   (__bridge void *)self);
}

- (id)init
{
	if (self = [super init]) {
		AudioSessionInitialize(NULL, NULL, NULL, NULL);
		
		//プロパティリスナーコールバック関数を登録します
		AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, //監視したいプロパティの識別子
										audioRouteChangeListenerCallback,       //コールバック関数への参照
										(__bridge void *)self);  //呼び出されるコールバック関数に渡されるためのデータです

	}
	return self;
}

/*
 @param inUserData オーディオセッションを初期化する際に指定したデータへのポインタです。
 このcallbackはObjctive-Cのクラス外で実装されているため、callback内で特定のオブジェクトにメッセージを送るためにはObjective-Cのポインタを渡す必要があります。
 @param inPropertyID このコールバック関数で通知を受ける対象プロパティの識別子です。
 @param inPropertyValueSize inPropertyValueパラメータに渡されたデータのサイズ(バイト単位)です
 @param inPropertyValue 監視しているプロパティの値です。
 kAudioSessionProperty_AudioRouteChangeを指定すると型はCFDictionaryRefとなります。
 */
void audioRouteChangeListenerCallback(void *inUserData,
									   AudioSessionPropertyID inPropertyID,
									   UInt32 inPropertyValueSize,
									   const void *inPropertyValue)
{
	if (inPropertyID != kAudioSessionProperty_AudioRouteChange) {
		return;
	}
	
	CFDictionaryRef routeChangeDictionary = inPropertyValue;
	CFNumberRef routeChangeReasonRef = CFDictionaryGetValue (routeChangeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
	SInt32 routeChangeReason;
	CFNumberGetValue(routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
	
	if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable
		|| routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable) {
		
		YIHeadphonesDetector *headphonesDetector = (__bridge YIHeadphonesDetector *)inUserData;
		
		if ([headphonesDetector.delegate respondsToSelector:@selector(headphonesDetectorStateChanged:) ]) {
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
		//__bridge_transferにしてrouteがreleaseされるようにする
		NSString *routeString = (__bridge_transfer NSString *)route;
		
		if ([routeString isEqualToString:@"Headphone"] == YES) {
			result = YES;
		}
	}
	return result;
}


@end
