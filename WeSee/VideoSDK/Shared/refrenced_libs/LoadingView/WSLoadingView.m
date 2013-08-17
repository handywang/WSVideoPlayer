//
//  SNVideoLoadingView.m
//  sohunewsipad
//
//  Created by guoyalun on 12/11/12.
//  Copyright (c) 2012 sohu. All rights reserved.
//

#import "WSLoadingView.h"
#import <QuartzCore/QuartzCore.h>

#define kLoadingViewWidth                       (144.0f)
#define kLoadingViewHeight                      (144.0f)

@interface WSLoadingView() {
    UIImageView *_bgView;
}
@end

@implementation WSLoadingView
- (id)initWithSuperView:(UIView *)superView {
        CGRect _superViewFrame = superView.frame;
        CGRect _frame = CGRectMake((CGRectGetWidth(_superViewFrame)-kLoadingViewWidth)/2.0f, (CGRectGetHeight(_superViewFrame)-kLoadingViewHeight)/2.0f, kLoadingViewWidth, kLoadingViewHeight);
    
    self = [super initWithFrame:_frame];
    if (self) {
        self.layer.cornerRadius = 20;
        self.layer.borderColor  = [UIColor whiteColor].CGColor;
        self.layer.borderWidth  = 1;
        
        self.backgroundColor    = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.hidden = YES;
        
        UIImage *_videoLoadingBg    = [UIImage imageNamed:@"videoloading_bg.png"];
        _bgView                     = [[UIImageView alloc] initWithImage:_videoLoadingBg];
        _bgView.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        CGSize _loadingBgSize       = _videoLoadingBg.size;
        _bgView.frame               = CGRectMake((CGRectGetWidth(self.bounds)-_loadingBgSize.width)/2,
                                                 (CGRectGetHeight(self.bounds)-_loadingBgSize.height)/2,
                                                 _loadingBgSize.width,
                                                 _loadingBgSize.height);
        [self addSubview:_bgView];
        
        
        UIImage *_videoLoadingIndicator = [UIImage imageNamed:@"videoloading_indicator.png"];
        indicatorView                   = [[UIImageView alloc] initWithImage:_videoLoadingIndicator];
        indicatorView.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        CGSize _contentSize             = _videoLoadingIndicator.size;
        indicatorView.frame             = CGRectMake((CGRectGetWidth(self.bounds)-_contentSize.width)/2,
                                                     (CGRectGetHeight(self.bounds)-_contentSize.height)/2,
                                                     _contentSize.width,
                                                     _contentSize.height);
        [self addSubview:indicatorView];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}


- (void)dealloc {
    [_bgView release]; _bgView = nil;
    [indicatorView release]; indicatorView = nil;
    [super dealloc];
}


- (void)startAnimation {
    self.hidden = NO;

    CABasicAnimation *expandbBundsAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [expandbBundsAnimation setRemovedOnCompletion:YES];
    [expandbBundsAnimation setFromValue:[NSValue valueWithCATransform3D: CATransform3DMakeRotation(0, 0, 0, 1.0)]];
    [expandbBundsAnimation setToValue:[NSValue valueWithCATransform3D: CATransform3DMakeRotation(0.9999* M_PI, 0, 0, 1.0)]];
    [expandbBundsAnimation setDuration:0.8f];
    [expandbBundsAnimation setRepeatCount:HUGE_VALF];
    [expandbBundsAnimation setCumulative:YES];
    [indicatorView.layer addAnimation:expandbBundsAnimation forKey:@"transform"];
}


- (void)stopAnimation
{
    [indicatorView.layer removeAllAnimations];
    self.hidden = YES;
}


@end
