//
//  WSMVVideoPlayerView.m
//  WeSee
//
//  Created by handy wang on 8/14/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSMVVideoPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "WSMVVideoPlayerViewObserver.h"
#import "UIViewAdditions.h"
#import "WSMVVideoControlBar.h"
#import "WSMVProgressSlider.h"

#define kThumbnailBtnWidth                      (64.0f)
#define kThumbnailBtnHeight                     (64.0f)

@interface WSMVVideoPlayerView()
@property (nonatomic, retain)UIImageView *poster;
@property (nonatomic, retain)UIButton *posterPlayBtn;
@property (nonatomic, retain)MPMoviePlayerViewController *playerViewController;
@property (nonatomic, retain)WSMVVideoPlayerViewObserver *observer;
@property (nonatomic, retain)WSMVVideoControlBar         *controlBar;
@property (nonatomic, assign)CGFloat                     rateBeforeTappingProgressBar;
@property (nonatomic, retain)NSTimer                     *playbackTimeTimer;
@end

@implementation WSMVVideoPlayerView

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //===Load video resource
//        _playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"http://live.gslb.letv.com/gslb?stream_id=cctvnew&tag=live&ext=m3u8&sign=live_ipad"]];

        _playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"http://data.vod.itc.cn/?new=/190/139/Sw0NUHpzEQLrAisgiAUXn4.mp4&ch=tv&cateCode=115101;115102;115103;115104&plat=null"]];
        
        [_playerViewController.moviePlayer setShouldAutoplay:NO];
        [_playerViewController.moviePlayer prepareToPlay];
        [_playerViewController.moviePlayer setControlStyle:MPMovieControlStyleNone];
        [self addSubview:_playerViewController.view];

        //===Add notitification observer
        self.observer = [[[WSMVVideoPlayerViewObserver alloc] init] autorelease];
        self.observer.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self.observer
                                                 selector:@selector(moviePlayerLoadStateDidChange:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:self.playerViewController.moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self.observer
                                                 selector:@selector(moviePlayerPlaybackStateDidChange:)
                                                     name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                   object:self.playerViewController.moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self.observer
                                                 selector:@selector(moviePlayerPlaybackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.playerViewController.moviePlayer];
        
        //Poster
        self.poster = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
        self.poster.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.poster.image = [UIImage imageNamed:@"default_poster.jpg"];
        self.poster.userInteractionEnabled = YES;
        [self addSubview:self.poster];
        
        //Poster button
        self.posterPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.posterPlayBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        self.posterPlayBtn.backgroundColor = [UIColor clearColor];
        self.posterPlayBtn.frame = CGRectMake((self.poster.width-kThumbnailBtnWidth)/2.0f,
                                                 (self.poster.height-kThumbnailBtnHeight)/2.0f,
                                                 kThumbnailBtnWidth,
                                                 kThumbnailBtnHeight);
        [self.posterPlayBtn setImage:[UIImage imageNamed:@"contentPlayHolder.png"] forState:UIControlStateNormal];
        [self.posterPlayBtn setImage:[UIImage imageNamed:@"contentPlayHolderpress.png"] forState:UIControlStateHighlighted];
        [self.posterPlayBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
        [self.poster addSubview:self.posterPlayBtn];
        
        //Control bar
        CGRect _controlBarFrame = CGRectZero;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            _controlBarFrame = CGRectMake(0, CGRectGetHeight(self.bounds)-kControlBarHeight_Phone, self.bounds.size.width, kControlBarHeight_Phone);
        } else {
            _controlBarFrame = CGRectMake(0, CGRectGetHeight(self.bounds)-kControlBarHeight_Pad, self.bounds.size.width, kControlBarHeight_Pad);
        }
        self.controlBar = [[[WSMVVideoControlBar alloc] initWithFrame:_controlBarFrame] autorelease];
        self.controlBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        self.controlBar.delegate = self;
        [self addSubview:self.controlBar];
    }
    return self;
}

- (void)dealloc {
    self.posterPlayBtn = nil;
    self.poster = nil;
    
    [self removePlaybackTimeObserver];
    
    self.observer.delegate = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self.observer];
    self.observer = nil;
    [self stop];
    self.playerViewController = nil;
    
    self.controlBar.delegate = nil;
    self.controlBar = nil;
    
    [super dealloc];
}

#pragma mark - Public
- (void)pause {
    [self.playerViewController.moviePlayer pause];
}

- (void)stop {
    [self.playerViewController.moviePlayer stop];
}

- (void)play {
    [self.playerViewController.moviePlayer play];
}

#pragma mark - Private
- (void)addPlaybackTimeObserver {
    [self removePlaybackTimeObserver];
    
    CGFloat _duration = self.playerViewController.moviePlayer.duration;
    if (_duration > 0) {
        [self.controlBar.progressBar setTimeLabelTextToNonLive];
        self.playbackTimeTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self.observer selector:@selector(playbackTimeDidChanged) userInfo:nil repeats:YES];
    } else {
        [self.controlBar.progressBar setTimeLabelTextToLive];
    }
}

- (void)removePlaybackTimeObserver {
    if (self.playbackTimeTimer) {
        [self.playbackTimeTimer invalidate];
        self.playbackTimeTimer = nil;
    }
}

#pragma mark - WSMVVideoPlayerViewObserverDelegate
- (void)readyToPlay {
    [self addPlaybackTimeObserver];
}

- (void)videoDidPlay {
    self.poster.hidden = YES;
    [self addPlaybackTimeObserver];
    [self.controlBar setPlayBtnStatus:WSMVVideoPlayerPlayBtnStatus_Playing];
}

- (void)videoDidPause {
    [self.controlBar setPlayBtnStatus:WSMVVideoPlayerPlayBtnStatus_Pause];
}

- (void)videoDidStop {
    [self.controlBar setPlayBtnStatus:WSMVVideoPlayerPlayBtnStatus_Stop];
    
    [self removePlaybackTimeObserver];
    self.playerViewController.moviePlayer.currentPlaybackTime = 0;
    [self.controlBar.progressBar resetTimeLabel];
}

- (void)videoDidFinish {
    [self.controlBar setPlayBtnStatus:WSMVVideoPlayerPlayBtnStatus_Stop];
    
    [self removePlaybackTimeObserver];
    self.playerViewController.moviePlayer.currentPlaybackTime = 0;
    [self.controlBar.progressBar resetTimeLabel];
}

- (void)playbackTimeDidChanged {
    NSTimeInterval _duration = self.playerViewController.moviePlayer.duration;
    NSTimeInterval _currentPlaybackTime = self.playerViewController.moviePlayer.currentPlaybackTime;
    [self.controlBar.progressBar updateToCurrentTime:_currentPlaybackTime duration:_duration];
}

#pragma mark - WSVideoPlayerToolBarDelegate
- (void)didTapToPlay {
    NSLogInfo(@"INFO: Tap to play...");
    [self play];
}

- (void)didTapToPause {
    NSLogInfo(@"INFO: Tap to pause...");
    [self pause];
}

- (void)didTapPlaylistBtn {
    NSLogInfo(@"INFO: Tapped playlist btn...");
    
//    [UIView animateWithDuration:0.2 animations:^{
//        if (self.playlistView.left < self.width) {
//            self.playlistView.left = self.width;
//        } else {
//            self.playlistView.left = self.width-self.playlistView.width;
//        }
//    }];
}

#pragma mark - WSMVProgressSliderDelegate
- (void)didTouchDown:(WSMVProgressSlider *)progressSlider {
    //---如果是直播就直接返回
    NSTimeInterval playerDuration = [self.playerViewController.moviePlayer duration];
    if (playerDuration <= 0) {
        return;
    }
    
    //---------
    self.rateBeforeTappingProgressBar = self.playerViewController.moviePlayer.currentPlaybackRate;
    [self pause];
    [self removePlaybackTimeObserver];
}

- (void)didTouchMove:(WSMVProgressSlider *)progressSlider {
}

- (void)didTouchUp:(WSMVProgressSlider *)progressSlider {
    //---
    NSTimeInterval duration = [self.playerViewController.moviePlayer duration];
    if (duration <= 0) {
        return;
    }

    float minValue  = [progressSlider minimumValue];
    float maxValue  = [progressSlider maximumValue];
    float value     = [progressSlider value];
    double time = duration * (value - minValue) / (maxValue - minValue);
    self.playerViewController.moviePlayer.currentPlaybackTime = time;
    //---
    
    if (!self.playbackTimeTimer) {
        [self addPlaybackTimeObserver];
    }
    
    if (self.rateBeforeTappingProgressBar) {
        self.playerViewController.moviePlayer.currentPlaybackRate = self.rateBeforeTappingProgressBar;
        self.rateBeforeTappingProgressBar = 0.0f;
    }
}

- (void)didTouchCancel:(WSMVProgressSlider *)progressSlider {
}

@end