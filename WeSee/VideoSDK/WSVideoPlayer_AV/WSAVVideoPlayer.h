//
//  WSAVVideoPlayer.h
//  WeSee
//
//  Created by handy on 7/24/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSAVVideoPlayerToolBar.h"
#import "WSAVVideoPlaylistView.h"

@interface WSAVVideoPlayer : UIView<WSAVVideoPlayerToolBarDelegate, UIGestureRecognizerDelegate, WSAVVideoPlaylistViewDelegate>
@property(nonatomic, retain)NSMutableArray *videoModels;
@property(nonatomic, assign)id delegate;

- (void)stop;
@end