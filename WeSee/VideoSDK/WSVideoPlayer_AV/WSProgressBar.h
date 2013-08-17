//
//  WSProgressSlider.h
//  WeSee
//
//  Created by handy on 7/31/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSProgressSlider.h"

@interface WSProgressBar : UIView
@property (nonatomic, assign)id delegate;
@property (nonatomic, retain)WSProgressSlider *progressSlider;

- (void)initTimeLabelTextToNonLive;
- (void)initTimeLabelTextToLive;
- (void)updateToCurrentTime:(double)seconds duration:(double)duration;
@end