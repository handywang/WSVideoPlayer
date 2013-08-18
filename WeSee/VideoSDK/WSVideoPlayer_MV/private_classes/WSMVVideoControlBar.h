//
//  WSMVVideoControlBar.h
//  WeSee
//
//  Created by handy on 8/15/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSMVVideoProgressBar.h"

typedef enum {
    WSMVVideoPlayerPlayBtnStatus_Stop,
    WSMVVideoPlayerPlayBtnStatus_Playing,
    WSMVVideoPlayerPlayBtnStatus_Pause
} WSMVVideoPlayerPlayBtnStatus;

@interface WSMVVideoControlBar : UIView
@property (nonatomic, assign)id delegate;
@property (nonatomic, assign)WSMVVideoPlayerPlayBtnStatus playBtnStatus;
@property (nonatomic, retain)WSMVVideoProgressBar *progressBar;

- (void)setPlayBtnStatus:(WSMVVideoPlayerPlayBtnStatus)playBtnStatus;
@end

@protocol WSMVVideoControlBarDelegate
- (void)didTapToPlay;
- (void)didTapToPause;
- (void)didTapPlaylistBtn;
@end