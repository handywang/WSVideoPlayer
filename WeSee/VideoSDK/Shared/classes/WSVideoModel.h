//
//  WSVideoModel.h
//  WeSee
//
//  Created by handy on 7/24/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSVideoModel : NSObject

@property(nonatomic, copy)NSString          *title;
@property(nonatomic, copy)NSString          *poster;
@property(nonatomic, retain)NSMutableArray  *sources;

@end