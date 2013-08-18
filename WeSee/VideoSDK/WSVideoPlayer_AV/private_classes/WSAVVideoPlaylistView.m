//
//  WSVideoPlayllistView.m
//  WeSee
//
//  Created by handy wang on 7/25/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSAVVideoPlaylistView.h"

@interface WSAVVideoPlaylistView()
@property(nonatomic, retain)NSMutableArray *videoModels;
@end

@implementation WSAVVideoPlaylistView

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate   = self;
    }
    return self;
}

- (void)dealloc {
    self.videoModels = nil;
    self.delegate = nil;
    [super dealloc];
}

#pragma mark - Public
- (void)reloadModel:(NSMutableArray *)videoModels {
    self.videoModels = videoModels;
    [self reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *_cellIdentifier = @"TV_CHANNEL";
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    if (!_cell) {
        _cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIdentifier] autorelease];
    }
    
    WSVideoModel *_videoModel = [self.videoModels objectAtIndex:indexPath.row];
    _cell.textLabel.text = _videoModel.title;
    _cell.textLabel.font = [UIFont systemFontOfSize:18];
    return _cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_iDelegate respondsToSelector:@selector(didSelectAChannelAtIndex:)]) {
        [_iDelegate didSelectAChannelAtIndex:indexPath.row];
    }
}

@end