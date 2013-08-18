//
//  WSAVVideoPlayerMsgBox.m
//  WeSee
//
//  Created by handy wang on 7/25/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSAVVideoPlayerMsgBox.h"
#import "UIViewAdditions.h"
#import "WSUtility.h"

@interface WSAVVideoPlayerMsgBox() {
    BOOL _finishedToShowMsg;
}
@end

@implementation WSAVVideoPlayerMsgBox

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _finishedToShowMsg = YES;
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            self.textAlignment  = UITextAlignmentCenter;
        } else {
            self.textAlignment  = NSTextAlignmentCenter;
        }
        self.font               = [UIFont systemFontOfSize:30];
        self.textColor          = [UIColor blackColor];
        self.backgroundColor    = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        self.hidden             = YES;
    }
    return self;
}

- (void)dealloc {
    _finishedToShowMsg = YES;
    [super dealloc];
}

#pragma mark - Public
- (void)pushMsg:(NSString *)msg {
    if (!_finishedToShowMsg) {
        return;
    }
    [self.superview bringSubviewToFront:self];
    self.hidden = NO;
    
    _finishedToShowMsg = NO;
    
    if (msg.length <= 0) {
        msg = @"未知错误!";
    }
    self.text = msg;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.left = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.left = -self.width;
        } completion:^(BOOL finished) {
            self.text = @"(^-^)消息呢？(^-^)";
            self.hidden = YES;
            _finishedToShowMsg = YES;
        }];
    }];
}

@end
