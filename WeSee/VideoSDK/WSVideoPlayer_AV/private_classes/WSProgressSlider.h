//
//  WSProgressSlider.h
//  WeSee
//
//  Created by handy on 8/3/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSProgressSlider : UISlider
@property (nonatomic, assign)id delegate;
@end

@protocol WSProgressSliderDelegate
- (void)didTouchDown:(WSProgressSlider *)progressSlider;
- (void)didTouchMove:(WSProgressSlider *)progressSlider;
- (void)didTouchUp:(WSProgressSlider *)progressSlider;
- (void)didTouchCancel:(WSProgressSlider *)progressSlider;
@end