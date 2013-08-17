//
//  WSMVVideoProgressBar.h
//  WeSee
//
//  Created by handy on 8/15/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSMVVideoProgressBar : UIView
@property (nonatomic, assign)id delegate;

- (void)resetTimeLabel;
- (void)setTimeLabelTextToNonLive;
- (void)setTimeLabelTextToLive;
- (void)updateToCurrentTime:(double)seconds duration:(double)duration;
@end
