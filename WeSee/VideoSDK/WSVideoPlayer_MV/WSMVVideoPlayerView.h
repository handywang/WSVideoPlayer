//
//  WSMVVideoPlayerView.h
//  WeSee
//
//  Created by handy wang on 8/14/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSMVVideoPlayerView : UIView
@property(nonatomic, retain)NSMutableArray *videoModels;
@property (nonatomic, assign)id delegate;

- (void)play;
- (void)pause;
- (void)stop;
@end
