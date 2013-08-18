//
//  WSAVProgressSlider.h
//  WeSee
//
//  Created by handy on 8/3/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSAVProgressSlider : UISlider
@property (nonatomic, assign)id delegate;
@end

@protocol WSAVProgressSliderDelegate
- (void)didTouchDown:(WSAVProgressSlider *)progressSlider;
- (void)didTouchMove:(WSAVProgressSlider *)progressSlider;
- (void)didTouchUp:(WSAVProgressSlider *)progressSlider;
- (void)didTouchCancel:(WSAVProgressSlider *)progressSlider;
@end