//
//  WSVideoModel.m
//  WeSee
//
//  Created by handy on 7/24/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSVideoModel.h"

@implementation WSVideoModel

- (void)dealloc {
    self.title      = nil;
    self.poster     = nil;
    self.sources    = nil;
    [super dealloc];
}
@end