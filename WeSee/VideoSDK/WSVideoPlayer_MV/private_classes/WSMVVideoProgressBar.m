//
//  WSMVVideoProgressBar.m
//  WeSee
//
//  Created by handy on 8/15/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSMVVideoProgressBar.h"
#import "WSMVProgressSlider.h"

#define kTimeLabelTextFontSize                  (18.0f)

@interface WSMVVideoProgressBar()
@property (nonatomic, retain)UILabel *passedTimeLabel;
@property (nonatomic, retain)UILabel *leftTimeLabel;
@property (nonatomic, retain)WSMVProgressSlider *progressSlider;
@end

@implementation WSMVVideoProgressBar

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _passedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kProgressTimeLabelWidth, CGRectGetHeight(self.frame))];
        _passedTimeLabel.backgroundColor = [UIColor clearColor];
        _passedTimeLabel.textAlignment = UITextAlignmentCenter;
        _passedTimeLabel.font = [UIFont systemFontOfSize:kTimeLabelTextFontSize];
        _passedTimeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_passedTimeLabel];
        
        _leftTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-kProgressTimeLabelWidth,
                                                                   0,
                                                                   kProgressTimeLabelWidth,
                                                                   CGRectGetHeight(self.frame))];
        _leftTimeLabel.backgroundColor = [UIColor clearColor];
        _leftTimeLabel.textAlignment = UITextAlignmentCenter;
        _leftTimeLabel.font = [UIFont systemFontOfSize:kTimeLabelTextFontSize];
        _leftTimeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_leftTimeLabel];
        
        _progressSlider = [[WSMVProgressSlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_passedTimeLabel.frame),
                                                                             0,
                                                                             CGRectGetWidth(self.frame)-2*kProgressTimeLabelWidth,
                                                                             CGRectGetHeight(self.frame))];
        _progressSlider.delegate = self;
        _progressSlider.minimumValue = 0;
        _progressSlider.maximumValue = 1;
        _progressSlider.value = 0.0;
        [self addSubview:_progressSlider];
    }
    return self;
}

- (void)dealloc {
    self.passedTimeLabel = nil;
    self.leftTimeLabel = nil;
    self.progressSlider.delegate = nil;
    self.progressSlider = nil;
    [super dealloc];
}

#pragma mark - Public
- (void)resetTimeLabel {
    self.userInteractionEnabled = NO;
    self.progressSlider.enabled = NO;
    self.passedTimeLabel.text = @"00:00";
    self.leftTimeLabel.text = @"00:00";
    self.progressSlider.value = 0;
}

- (void)setTimeLabelTextToNonLive {
    self.userInteractionEnabled = YES;
    self.progressSlider.enabled = YES;
    self.passedTimeLabel.text = @"00:00";
    self.leftTimeLabel.text = @"00:00";
}

- (void)setTimeLabelTextToLive {
    self.userInteractionEnabled = NO;
    self.progressSlider.enabled = NO;
    self.progressSlider.value = 0;
    self.passedTimeLabel.text = @"Live";
    self.leftTimeLabel.text = @"Live";
}

- (void)updateToCurrentTime:(double)seconds duration:(double)duration {
    float minValue = [self.progressSlider minimumValue];
    float maxValue = [self.progressSlider maximumValue];
    [self.progressSlider setValue:(maxValue - minValue) * seconds / duration + minValue];
    
    NSString *_passedTime = [self getHumanReadableTime:seconds];
    self.passedTimeLabel.text = _passedTime;
    
    NSString *_leftTime = [self getHumanReadableTime:(duration-seconds)];
    self.leftTimeLabel.text = _leftTime;
    
//    NSLogInfo(@"===passedTime:%@, leftTime:%@", _passedTime, _leftTime);
}

- (NSString *)getHumanReadableTime:(double)secondsOfHumanUnreadable {
    NSUInteger dHours = floor(secondsOfHumanUnreadable / 3600);
    NSUInteger dMinutes = floor((NSUInteger)secondsOfHumanUnreadable%3600/60);
    NSUInteger dSeconds = floor((NSUInteger)secondsOfHumanUnreadable%3600%60);
    
    NSString *_humanReadableTime = nil;
    if (dHours>0) {
        _humanReadableTime = [NSString stringWithFormat:@"%i:%02i:%02i",dHours, dMinutes, dSeconds];
    } else {
        _humanReadableTime = [NSString stringWithFormat:@"%02i:%02i",dMinutes, dSeconds];
    }
    return _humanReadableTime;
}

#pragma mark - WSAVProgressSliderDelegate
- (void)didTouchDown:(WSMVProgressSlider *)progressSlider {
    if ([_delegate respondsToSelector:@selector(didTouchDown:)]) {
        [_delegate didTouchDown:progressSlider];
    }
}

- (void)didTouchMove:(WSMVProgressSlider *)progressSlider {
    if ([_delegate respondsToSelector:@selector(didTouchMove:)]) {
        [_delegate didTouchMove:progressSlider];
    }
}

- (void)didTouchUp:(WSMVProgressSlider *)progressSlider {
    if ([_delegate respondsToSelector:@selector(didTouchUp:)]) {
        [_delegate didTouchUp:progressSlider];
    }
}

- (void)didTouchCancel:(WSMVProgressSlider *)progressSlider {
    if ([_delegate respondsToSelector:@selector(didTouchCancel:)]) {
        [_delegate didTouchCancel:progressSlider];
    }
}

@end