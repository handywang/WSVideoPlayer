//
//  WSMVProgressSlider.h
//  WeSee
//
//  Created by handy on 8/3/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSMVProgressSlider : UISlider
@property (nonatomic, assign)id delegate;
@end

@protocol WSMVProgressSliderDelegate
- (void)didTouchDown:(WSMVProgressSlider *)progressSlider;
- (void)didTouchMove:(WSMVProgressSlider *)progressSlider;
- (void)didTouchUp:(WSMVProgressSlider *)progressSlider;
- (void)didTouchCancel:(WSMVProgressSlider *)progressSlider;
@end