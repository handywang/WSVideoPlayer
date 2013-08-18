//
//  WSAVVideoVolumeButton.m
//  WeSee
//
//  Created by handy on 8/17/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSAVVideoVolumeButton.h"
#import "UIViewAdditions.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import "WSUtility.h"
#import "WSConst.h"

void audioVolumeChangeListenerCallback (void *inUserData,
                                        AudioSessionPropertyID inPropertyID,
                                        UInt32 inPropertyValueSize,
                                        const void *inPropertyValue) {
    if (inPropertyID != kAudioSessionProperty_CurrentHardwareOutputVolume) return;
    Float32 value = *(Float32 *)inPropertyValue;
    UIImageView *_volumeView = (UIImageView *)inUserData;
    
    int _index = floorf(value*17+0.5);
    if (_index<0) _index = 0;
    if (_index>17) _index = 17;
    _volumeView.image = [UIImage imageNamed:[NSString stringWithFormat:@"volume_%d.png", _index]];
}

@interface WSAVVideoVolumeButton()
@property (nonatomic, retain)UIImageView *volumeView;
@end

@implementation WSAVVideoVolumeButton

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *_tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"volume_%d.png", [self initialVolumeImageIndex]]];
        CGFloat _left = (self.width-_tempImage.size.width)/2.0f;
        CGFloat _top = (self.height-_tempImage.size.height)/2.0f;
        _volumeView = [[UIImageView alloc] initWithFrame:CGRectMake(_left,
                                                                    _top,
                                                                    _tempImage.size.width,
                                                                    _tempImage.size.height)];
        _volumeView.image = _tempImage;
        [self addSubview:_volumeView];
        
        AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume, audioVolumeChangeListenerCallback, self.volumeView);
    }
    return self;
}

- (void)dealloc {
    self.volumeView = nil;
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume,
                                                   audioVolumeChangeListenerCallback, self.volumeView);
    [super dealloc];
}

#pragma mark -
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint _location = [[touches anyObject] locationInView:self];
    int _index = [self volumeImageIndexAtLocation:_location];
    self.volumeView.image = [UIImage imageNamed:[NSString stringWithFormat:@"volume_%d.png", _index]];
    
    Float32 _volumeValue = _index*1.0f/17.0f;
    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
    mpc.volume = _volumeValue;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

#pragma mark - Private
//Dont work on simulator but device.
- (CGFloat)systemVolume {
    Float32 systemVolume;
    UInt32 dataSize = sizeof(Float32);
    AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareOutputVolume,
                             &dataSize,&systemVolume);
    return systemVolume;
}

- (int)volumeImageIndexAtLocation:(CGPoint)location {
    int _index = floorf(location.x/self.width*17+0.5);
    if (_index<0) {
        _index = 0;
    }
    if (_index>17) {
        _index = 17;
    }
    NSLogInfo(@"===Volume image index:%d", _index);
    return _index;
}

- (int)initialVolumeImageIndex {
    int _index = floorf([self systemVolume]*17+0.5);
    if (_index < 0) _index = 0;
    if (_index > 17) _index = 17;
    NSLogInfo(@"===Initial volume image index:%d", _index);
    return _index;
}

@end