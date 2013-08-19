//
//  WSMVVideoPlayerViewObserver.h
//  WeSee
//
//  Created by handy wang on 8/14/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSMVVideoPlayerViewObserver : NSObject
@property (nonatomic, assign)id delegate;

- (void)moviePlayerLoadStateDidChange:(NSNotification *)notification;
- (void)moviePlayerPlaybackStateDidChange:(NSNotification *)notification;
- (void)moviePlayerPlaybackDidFinish:(NSNotification *)notification;

- (void)playbackTimeDidChanged;
@end

@protocol WSMVVideoPlayerViewObserverDelegate
- (void)readyToPlay;

- (void)videoDidPlay;
- (void)videoDidPause;
- (void)videoDidStop;
- (void)videDidInterrupted;
- (void)videoDidFinish;

- (void)playbackTimeDidChanged;
@end