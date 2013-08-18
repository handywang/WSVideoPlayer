//
//  WSMVVideoControlBar.m
//  WeSee
//
//  Created by handy on 8/15/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSMVVideoControlBar.h"
#import "UIViewAdditions.h"
#import "WSMVProgressSlider.h"
#import "WSConst.h"

@interface WSMVVideoControlBar()
@property (nonatomic, retain)UIButton *playBtn;
@end

@implementation WSMVVideoControlBar

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect _playBtnFrame = CGRectMake(0, (CGRectGetHeight(self.bounds)-self.height)/2.0f, self.height+20, self.height);
        self.playBtn.frame = _playBtnFrame;
        [self.playBtn setImage:[UIImage imageNamed:@"full_play.png"] forState:UIControlStateNormal];
        [self.playBtn setImage:[UIImage imageNamed:@"full_play_hl.png"] forState:UIControlStateHighlighted];
        self.playBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.playBtn addTarget:self action:@selector(tapPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.playBtnStatus = WSMVVideoPlayerPlayBtnStatus_Stop;
        self.playBtn.exclusiveTouch = YES;
        [self addSubview:self.playBtn];
        
        CGRect _progressBarFrame = CGRectMake(CGRectGetMaxX(self.playBtn.frame)+kProgressBarPaddingLeftToPlayBtn,
                                              (self.height-CGRectGetHeight(self.frame))/2.0f,
                                              kProgressBarWidth,
                                              CGRectGetHeight(self.frame));
        self.progressBar = [[[WSMVVideoProgressBar alloc] initWithFrame:_progressBarFrame] autorelease];
        self.progressBar.delegate = self;
        self.progressBar.exclusiveTouch = YES;
        [self addSubview:self.progressBar];
    }
    return self;
}

- (void)dealloc {
    self.playBtn = nil;
    self.progressBar.delegate = nil;
    self.progressBar = nil;
    [super dealloc];
}

#pragma mark - Public
- (void)setPlayBtnStatus:(WSMVVideoPlayerPlayBtnStatus)playBtnStatus {
    _playBtnStatus = playBtnStatus;
    
    if (_playBtnStatus == WSMVVideoPlayerPlayBtnStatus_Stop || _playBtnStatus == WSMVVideoPlayerPlayBtnStatus_Pause) {
        [self.playBtn setImage:[UIImage imageNamed:@"full_play.png"] forState:UIControlStateNormal];
        [self.playBtn setImage:[UIImage imageNamed:@"full_play_hl.png"] forState:UIControlStateHighlighted];
    } else if (_playBtnStatus == WSMVVideoPlayerPlayBtnStatus_Playing) {
        [self.playBtn setImage:[UIImage imageNamed:@"full_pause.png"] forState:UIControlStateNormal];
        [self.playBtn setImage:[UIImage imageNamed:@"full_pause_hl.png"] forState:UIControlStateHighlighted];
    }
}

#pragma mark - Private
- (void)tapPlayBtn:(id)sender {
    if (self.playBtnStatus == WSMVVideoPlayerPlayBtnStatus_Stop || self.playBtnStatus == WSMVVideoPlayerPlayBtnStatus_Pause) {
        if ([self.delegate respondsToSelector:@selector(didTapToPlay)]) {
            [self.delegate didTapToPlay];
        }
    } else if (self.playBtnStatus == WSMVVideoPlayerPlayBtnStatus_Playing) {
        if ([self.delegate respondsToSelector:@selector(didTapToPause)]) {
            [self.delegate didTapToPause];
        }
    }
}

#pragma mark - WSMVProgressSliderDelegate
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
