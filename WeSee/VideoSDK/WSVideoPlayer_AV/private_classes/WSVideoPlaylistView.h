//
//  WSVideoPlayllistView.h
//  WeSee
//
//  Created by handy wang on 7/25/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSVideoModel.h"

@interface WSVideoPlaylistView : UITableView<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, assign)id iDelegate;

- (void)reloadModel:(NSMutableArray *)videoModels;
@end

@protocol WSVideoPlaylistViewDelegate
- (void)didSelectAChannelAtIndex:(NSInteger)index;
@end