//
//  WSMVVideoPlayerViewObserver.m
//  WeSee
//
//  Created by handy wang on 8/14/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSMVVideoPlayerViewObserver.h"
#import <MediaPlayer/MediaPlayer.h>

NSString *NSStringFromMPMovieLoadState(MPMovieLoadState loadState) {
    switch (loadState) {
        case MPMovieLoadStateUnknown: {
            return @"MPMovieLoadStateUnknown";
            break;
        }
        case MPMovieLoadStatePlayable: {
            return @"MPMovieLoadStatePlayable";
            break;
        }
        case MPMovieLoadStatePlaythroughOK: {
            return @"MPMovieLoadStatePlaythroughOK";
            break;
        }
        case MPMovieLoadStateStalled: {
            return @"MPMovieLoadStateStalled";
            break;
        }
        default: {
            return nil;
            break;
        }
    }
}

NSString *NSStringFromMPMoviePlaybackState(MPMoviePlaybackState playbackState) {
    switch (playbackState) {
        case MPMoviePlaybackStateStopped: {
            return @"MPMoviePlaybackStateStopped";
            break;
        }
        case MPMoviePlaybackStatePlaying: {
            return @"MPMoviePlaybackStatePlaying";
            break;
        }
        case MPMoviePlaybackStatePaused: {
            return @"MPMoviePlaybackStatePaused";
            break;
        }
        case MPMoviePlaybackStateInterrupted: {
            return @"MPMoviePlaybackStateInterrupted";
            break;
        }
        case MPMoviePlaybackStateSeekingForward: {
            return @"MPMoviePlaybackStateSeekingForward";
            break;
        }
        case MPMoviePlaybackStateSeekingBackward: {
            return @"MPMoviePlaybackStateSeekingBackward";
            break;
        }
        default: {
            return nil;
            break;
        }
    }
}
//====================================================================
//====================================================================
//====================================================================

@implementation WSMVVideoPlayerViewObserver

#pragma mark - Notification callbacks
- (void)moviePlayerLoadStateDidChange:(NSNotification *)notification {
    MPMoviePlayerController *_playerController = [self playerController:notification];
    MPMovieLoadState _loadState = [_playerController loadState];
    NSLogInfo(@"===Load state changed to %d/%@", _loadState, NSStringFromMPMovieLoadState(_loadState));
    
    if (_loadState == MPMovieLoadStatePlayable) {
        NSLogInfo(@"===Ready to play...");
        if ([_delegate respondsToSelector:@selector(readyToPlay)]) {
            [_delegate readyToPlay];
        }
    }
}

- (void)moviePlayerPlaybackStateDidChange:(NSNotification *)notification {
    MPMoviePlayerController *_playerController = [self playerController:notification];
    MPMoviePlaybackState _playbackState = [_playerController playbackState];
    NSLogInfo(@"===Playback state changed to %d/%@", _playbackState, NSStringFromMPMoviePlaybackState(_playbackState));
    
    if (_playbackState == MPMoviePlaybackStatePlaying) {
        if ([_delegate respondsToSelector:@selector(videoDidPlay)]) {
            [_delegate videoDidPlay];
        }
    } else if (_playbackState == MPMoviePlaybackStatePaused) {
        if ([_delegate respondsToSelector:@selector(videoDidPause)]) {
            [_delegate videoDidPause];
        }
    } else if ((_playbackState == MPMoviePlaybackStateStopped) || (_playbackState == MPMoviePlaybackStateInterrupted)) {
        if ([_delegate respondsToSelector:@selector(videoDidStop)]) {
            [_delegate videoDidStop];
        }
    }
}

//当点击Done按键或者播放完毕时调用此函数
- (void)moviePlayerPlaybackDidFinish:(NSNotification *)notification {
    NSLogInfo(@"===Playback did finish.");
    if ([_delegate respondsToSelector:@selector(videoDidFinish)]) {
        [_delegate videoDidFinish];
    }
}

#pragma mark -
- (void)playbackTimeDidChanged {
    if ([_delegate respondsToSelector:@selector(playbackTimeDidChanged)]) {
        [_delegate playbackTimeDidChanged];
    }
}

#pragma mark - Private
- (MPMoviePlayerController *)playerController:(NSNotification *)notification {
    id _obj = [notification object];
    if ([_obj isKindOfClass:[MPMoviePlayerController class]]) {
        MPMoviePlayerController *_moviePlayerController = (MPMoviePlayerController *)_obj;
        return _moviePlayerController;
    } else {
        return nil;
    }
}

@end