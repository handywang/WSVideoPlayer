//
//  WSVideoPlayerToolBar.h
//  WeSee
//
//  Created by handy on 7/24/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSProgressBar.h"

typedef enum {
    WSVideoPlayerPlayBtnStatus_Stop,
    WSVideoPlayerPlayBtnStatus_Playing,
    WSVideoPlayerPlayBtnStatus_Pause
} WSVideoPlayerPlayBtnStatus;

@interface WSVideoPlayerToolBar : UIView
@property(nonatomic, assign)id delegate;
@property(nonatomic, assign)WSVideoPlayerPlayBtnStatus playBtnStatus;
@property(nonatomic, retain)WSProgressBar    *progressBar;

- (void)setPlayBtnStatus:(WSVideoPlayerPlayBtnStatus)playBtnStatus;
@end

@protocol WSVideoPlayerToolBarDelegate
- (void)didTapToPlay;
- (void)didTapToPause;
- (void)didTapPlaylistBtn;
@end
