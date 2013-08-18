//
//  WSMVProgressSlider.m
//  WeSee
//
//  Created by handy on 8/3/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSMVProgressSlider.h"
#import "WSUtility.h"

@implementation WSMVProgressSlider

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.enabled = NO;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLogInfo(@"===progressSlider touchBegan...");
    if (!(self.isHighlighted)) {
        CGPoint _location = [[touches anyObject] locationInView:self];
        CGFloat _newValue = _location.x/self.frame.size.width;
        if (_newValue < self.minimumValue) {
            self.value = self.minimumValue;
        } else if (_newValue > self.maximumValue) {
            self.value = self.maximumValue;
        } else {
            self.value = _newValue;
        }
    }
    
    [super touchesBegan:touches withEvent:event];
    if ([_delegate respondsToSelector:@selector(didTouchDown:)]) {
        [_delegate didTouchDown:self];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLogInfo(@"===progressSlider touchMoved...");
    [super touchesMoved:touches withEvent:event];
    if ([_delegate respondsToSelector:@selector(didTouchMove:)]) {
        [_delegate didTouchMove:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLogInfo(@"===progressSlider touchEnded...");
    [super touchesEnded:touches withEvent:event];
    if ([_delegate respondsToSelector:@selector(didTouchUp:)]) {
        [_delegate didTouchUp:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLogInfo(@"===progressSlider touchCancelled...");
    [super touchesCancelled:touches withEvent:event];
    if ([_delegate respondsToSelector:@selector(didTouchCancel:)]) {
        [_delegate didTouchCancel:self];
    }
}

#pragma mark - Public
- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.userInteractionEnabled = enabled;
}

@end