//
//  WSAVVideoPlayerToolBar.m
//  WeSee
//
//  Created by handy on 7/24/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSAVVideoPlayerToolBar.h"
#import "UIViewAdditions.h"
#import "WSConst.h"
#import <QuartzCore/QuartzCore.h>
#import "WSVideoVolumeButton.h"

@interface WSAVVideoPlayerToolBar()
@property(nonatomic, retain)NSMutableArray      *assetArray;
@property(nonatomic, retain)UIButton            *playBtn;
@property(nonatomic, retain)UIButton            *playlistBtn;
@property(nonatomic, retain)WSVideoVolumeButton *soundVolumeBtn;
@end

@implementation WSAVVideoPlayerToolBar
@synthesize playBtnStatus = _playBtnStatus;

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect _playBtnFrame = CGRectMake(0, (CGRectGetHeight(self.bounds)-self.height)/2.0f, self.height+20, self.height);
        self.playBtn.frame = _playBtnFrame;
        [self.playBtn setImage:[UIImage imageNamed:@"full_play.png"] forState:UIControlStateNormal];
        [self.playBtn setImage:[UIImage imageNamed:@"full_play_hl.png"] forState:UIControlStateHighlighted];
        self.playBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.playBtn addTarget:self action:@selector(tapPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.playBtnStatus = WSVideoPlayerPlayBtnStatus_Stop;
        self.playBtn.exclusiveTouch = YES;
        [self addSubview:self.playBtn];
        
        self.playlistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat _playlistBtnWidth = self.height+20;
        CGRect _playlistBtnFrame = CGRectMake(CGRectGetWidth(self.bounds)-_playlistBtnWidth, (CGRectGetHeight(self.bounds)-self.height)/2.0f, _playlistBtnWidth, self.height);
        self.playlistBtn.frame = _playlistBtnFrame;
        [self.playlistBtn setImage:[UIImage imageNamed:@"full_playlist.png"] forState:UIControlStateNormal];
        [self.playlistBtn setImage:[UIImage imageNamed:@"full_playlist_hl.png"] forState:UIControlStateHighlighted];
        self.playlistBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.playlistBtn addTarget:self action:@selector(tapPlaylistBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.playlistBtn.exclusiveTouch = YES;
        [self addSubview:self.playlistBtn];
        
        self.soundVolumeBtn = [[WSVideoVolumeButton alloc] initWithFrame:CGRectMake(self.playlistBtn.left-self.playlistBtn.width,
                                                                                    0,
                                                                                    self.playlistBtn.width,
                                                                                    self.height)];
        self.soundVolumeBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.soundVolumeBtn];
        
        
        CGRect _progressBarFrame = CGRectMake(CGRectGetMaxX(self.playBtn.frame),
                                              (self.height-CGRectGetHeight(self.frame))/2.0f,
                                              self.playlistBtn.left-CGRectGetMaxX(self.playBtn.frame)-self.playlistBtn.width,
                                              CGRectGetHeight(self.frame));
        self.progressBar = [[[WSAVProgressBar alloc] initWithFrame:_progressBarFrame] autorelease];
        self.progressBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin;
        self.progressBar.delegate = self;
        self.progressBar.exclusiveTouch = YES;
        [self addSubview:self.progressBar];
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.assetArray = nil;
    self.playBtn = nil;
    self.playBtnStatus = WSVideoPlayerPlayBtnStatus_Stop;
    self.playlistBtn = nil;
    self.progressBar.delegate = nil;
    self.progressBar = nil;
    self.soundVolumeBtn = nil;
    [super dealloc];
}

#pragma mark - Public
- (void)setPlayBtnStatus:(WSVideoPlayerPlayBtnStatus)playBtnStatus {
    _playBtnStatus = playBtnStatus;
    if (_playBtnStatus == WSVideoPlayerPlayBtnStatus_Stop || _playBtnStatus == WSVideoPlayerPlayBtnStatus_Pause) {
        [self.playBtn setImage:[UIImage imageNamed:@"full_play.png"] forState:UIControlStateNormal];
        [self.playBtn setImage:[UIImage imageNamed:@"full_play_hl.png"] forState:UIControlStateHighlighted];
    } else if (_playBtnStatus == WSVideoPlayerPlayBtnStatus_Playing) {
        [self.playBtn setImage:[UIImage imageNamed:@"full_pause.png"] forState:UIControlStateNormal];
        [self.playBtn setImage:[UIImage imageNamed:@"full_pause_hl.png"] forState:UIControlStateHighlighted];
    }
}

#pragma mark - WSProgressSliderDelegate
- (void)didTouchDown:(WSProgressSlider *)progressSlider {
    if ([_delegate respondsToSelector:@selector(didTouchDown:)]) {
        [_delegate didTouchDown:progressSlider];
    }
}

- (void)didTouchMove:(WSProgressSlider *)progressSlider {
    if ([_delegate respondsToSelector:@selector(didTouchMove:)]) {
        [_delegate didTouchMove:progressSlider];
    }
}

- (void)didTouchUp:(WSProgressSlider *)progressSlider {
    if ([_delegate respondsToSelector:@selector(didTouchUp:)]) {
        [_delegate didTouchUp:progressSlider];
    }
}

- (void)didTouchCancel:(WSProgressSlider *)progressSlider {
    if ([_delegate respondsToSelector:@selector(didTouchCancel:)]) {
        [_delegate didTouchCancel:progressSlider];
    }
}

#pragma mark - Private
- (void)tapPlayBtn:(id)sender {
    if (self.playBtnStatus == WSVideoPlayerPlayBtnStatus_Stop || self.playBtnStatus == WSVideoPlayerPlayBtnStatus_Pause) {
        if ([self.delegate respondsToSelector:@selector(didTapToPlay)]) {
            [self.delegate didTapToPlay];
        }
    } else if (self.playBtnStatus == WSVideoPlayerPlayBtnStatus_Playing) {
        if ([self.delegate respondsToSelector:@selector(didTapToPause)]) {
            [self.delegate didTapToPause];
        }
    }
}

- (void)tapPlaylistBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didTapPlaylistBtn)]) {
        [self.delegate didTapPlaylistBtn];
    }
}

@end
