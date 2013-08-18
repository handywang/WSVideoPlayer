//
//  WSAVVideoPlayer.m
//  WeSee
//
//  Created by handy on 7/24/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSAVVideoPlayer.h"

#import "UIViewAdditions.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreMedia/CoreMedia.h>

#import "WSConst.h"
#import "WSVideoPlayerMsgBox.h"
#import "WSAVVideoPlayerToolBar.h"
#import "WSLoadingView.h"

/* Asset keys */
NSString * const kTracksKey         = @"tracks";
NSString * const kPlayableKey		= @"playable";
/* PlayerItem keys */
NSString * const kStatusKey         = @"status";
NSString * const kDurationKey       = @"duration";
/* AVPlayer keys */
NSString * const kRateKey			= @"rate";
NSString * const kCurrentItemKey	= @"currentItem";

static void *SNPlayerViewPlayerItemStatusObservationContext = &SNPlayerViewPlayerItemStatusObservationContext;
static void *SNPlayerViewPlaterItemDurationObservationContext= &SNPlayerViewPlaterItemDurationObservationContext;

static void *SNPlayerViewPlayerCurrentItemObservationContext =&SNPlayerViewPlayerCurrentItemObservationContext;
static void *SNPlayerViewPlayerRateObservationContext = &SNPlayerViewPlayerRateObservationContext;

@interface WSAVVideoPlayer()
@property(nonatomic, retain)WSLoadingView           *loadingView;
@property(nonatomic, retain)AVQueuePlayer           *player;
@property(nonatomic, retain)WSVideoPlayerMsgBox     *msgBox;
@property(nonatomic, retain)UIImageView             *poster;
@property(nonatomic, retain)WSAVVideoPlayerToolBar    *toolBar;
@property(nonatomic, assign)BOOL                    isFinishedToShowOrHideToolBar;
@property(nonatomic, retain)WSAVVideoPlaylistView     *playlistView;

@property(nonatomic, retain)NSMutableArray          *assetArray;
@property(nonatomic, retain)NSMutableArray          *playerItemArray;
@property(nonatomic, assign)NSInteger               selectedChannelIndex;

@property(nonatomic, assign)id                      mTimeObserver;
@property(nonatomic, assign)id                      boundaryTimeObserver;
@property(nonatomic, assign)CGFloat                 rateBeforeTappingProgressBar;
@end

@implementation WSAVVideoPlayer

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        
        self.assetArray         = [NSMutableArray array];
        self.playerItemArray    = [NSMutableArray array];
                
        CGRect _msgBoxFrame = CGRectMake(-kMsgBoxWidth, (self.height-kMsgBoxHeight)/2.0f, kMsgBoxWidth, kMsgBoxHeight);
        self.msgBox = [[[WSVideoPlayerMsgBox alloc] initWithFrame:_msgBoxFrame] autorelease];
        self.msgBox.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:self.msgBox];
        
        CGRect _posterFrame = CGRectMake(0, 0, self.width, self.height);
        self.poster = [[[UIImageView alloc] initWithFrame:_posterFrame] autorelease];
        self.poster.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.poster];

        CGRect _toolBarFrame = CGRectZero;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            _toolBarFrame = CGRectMake(0, CGRectGetHeight(self.bounds)-kToolBarHeight_Phone, self.bounds.size.width, kToolBarHeight_Phone);
        } else {
            _toolBarFrame = CGRectMake(0, CGRectGetHeight(self.bounds)-kToolBarHeight_Pad, self.bounds.size.width, kToolBarHeight_Pad);
        }
        self.toolBar = [[[WSAVVideoPlayerToolBar alloc] initWithFrame:_toolBarFrame] autorelease];
        self.toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        self.toolBar.delegate = self;
        [self addSubview:self.toolBar];
        self.isFinishedToShowOrHideToolBar = YES;
        
        CGRect _playlistViewFrame = CGRectMake(self.width, 0, kPlaylistViewWidth, CGRectGetHeight(self.bounds));
        self.playlistView = [[[WSAVVideoPlaylistView alloc] initWithFrame:_playlistViewFrame style:UITableViewStylePlain] autorelease];
        self.playlistView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin;
        self.playlistView.iDelegate = self;
        self.playlistView.hidden = YES;
        [self addSubview:self.playlistView];
        
        self.loadingView = [[[WSLoadingView alloc] initWithSuperView:self] autorelease];
        self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.loadingView];
        
        UITapGestureRecognizer *_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVideoPlayer)];
        _tapGesture.delegate = self;
        [self addGestureRecognizer:_tapGesture];
        [_tapGesture release];
        _tapGesture = nil;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self removePlayerTimeObserver];
    
    [self.player removeObserver:self forKeyPath:kRateKey];
    [self.player removeObserver:self forKeyPath:kCurrentItemKey];
    [self.player pause];
    self.player = nil;
    
    for (AVPlayerItem *_playerItem in self.playerItemArray) {
        [_playerItem removeObserver:self forKeyPath:kStatusKey];
    }
    
    self.loadingView        = nil;
    
    self.msgBox             = nil;
    self.poster             = nil;
    self.toolBar.delegate   = nil;
    self.toolBar            = nil;
    _isFinishedToShowOrHideToolBar = YES;
    self.playlistView       = nil;
    
    self.videoModels        = nil;
    self.assetArray         = nil;
    self.playerItemArray    = nil;
    
    self.delegate           = nil;
    [super dealloc];
}

#pragma mark - Public
- (void)stop {
    [self.player pause];
    
    for (AVPlayerItem *_playerItem in self.playerItemArray) {
        [_playerItem removeObserver:self forKeyPath:kStatusKey];
    }
    
    [self.player removeObserver:self forKeyPath:kCurrentItemKey context:SNPlayerViewPlayerCurrentItemObservationContext];
    [self.player removeObserver:self forKeyPath:kRateKey context:SNPlayerViewPlayerRateObservationContext];
    
    [self.player removeAllItems];
    self.player = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Override
- (void)setVideoModels:(NSMutableArray *)videoModels {
    if (_videoModels != videoModels) {
        [_videoModels release];
        _videoModels = nil;
        _videoModels = [videoModels retain];
        [self.playlistView reloadModel:_videoModels];
        
        if (_videoModels.count > 0) {
            WSVideoModel *_firstModel = [_videoModels objectAtIndex:0];
            self.poster.image = [UIImage imageNamed:_firstModel.poster];
        }
    }
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return [touch.view isKindOfClass:[WSAVVideoPlayer class]];
}

#pragma mark - WSAVVideoPlayerToolBarDelegate
- (void)didTapToPlay {
    NSLogInfo(@"INFO: Tap to play...");
    [self play];
}

- (void)didTapToPause {
    NSLogInfo(@"INFO: Tap to pause...");
    [self pause];
}

- (void)didTapPlaylistBtn {
    NSLogInfo(@"INFO: Tapped playlist btn...");
    BOOL _isPlaylistShown = (self.playlistView.left < self.width);
    if (_isPlaylistShown) [self hidePlaylistView]; else [self showPlaylistView];
}

#pragma mark - WSAVVideoPlaylistViewDelegate
- (void)didSelectAChannelAtIndex:(NSInteger)index {
    [self hidePlaylistView];
    
    _selectedChannelIndex = index;
    
    if (_selectedChannelIndex < self.videoModels.count) {
        WSVideoModel *_videoModel = [self.videoModels objectAtIndex:_selectedChannelIndex];
        [self loadVideoSourceAndReadyToPlay:_videoModel];
    } else {
        [self noVideoSourceToPlay];
    }
}

#pragma mark - WSProgressSliderDelegate
- (void)didTouchDown:(WSProgressSlider *)progressSlider {
    //---如果是直播就直接返回
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (!isfinite(duration)) {
        //Live
        return;
    }
    
    //---------
    self.rateBeforeTappingProgressBar = self.player.rate;
    [self pause];
    [self removePlayerTimeObserver];
}

- (void)didTouchMove:(WSProgressSlider *)progressSlider {
}

- (void)didTouchUp:(WSProgressSlider *)progressSlider {
    //---
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration)) {
        float minValue  = [progressSlider minimumValue];
        float maxValue  = [progressSlider maximumValue];
        float value     = [progressSlider value];
        double time = duration * (value - minValue) / (maxValue - minValue);
        [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
    } else {
        return;
    }
    //---
    
    if (!_mTimeObserver) {
        [self addScrubberTimer];
    }
    
    if (self.rateBeforeTappingProgressBar) {
        [self.player setRate:_rateBeforeTappingProgressBar];
        _rateBeforeTappingProgressBar = 0.0f;
    }
}

- (void)didTouchCancel:(WSProgressSlider *)progressSlider {
}

#pragma mark - KVO
//Observation for player and playerItem.
- (void)observeValueForKeyPath:(NSString*) path ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    
	/* AVPlayerItem "status" property value observer. */
	if (context == SNPlayerViewPlayerItemStatusObservationContext) {
        NSLogInfo(@"======Observed context 'playerItem status' changed.");
        
        if ([object isKindOfClass:[AVPlayerItem class]]) {
            AVPlayerItem *_playerItem = (AVPlayerItem *)object;
            AVPlayerItemStatus _status = _playerItem.status;
//            AVPlayerItemStatus _status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            switch (_status) {
                    /* Indicates that the status of the player is not yet known because
                     it has not tried to load new media resources for playback */
                case AVPlayerItemStatusUnknown: {
                    NSLogInfo(@"======Observed playerItem status changed to 'AVPlayerStatusUnknown'");
                    [self removePlayerTimeObserver];
                    [self syncScrubber];
                    break;
                }
                case AVPlayerItemStatusReadyToPlay: {
                    NSLogInfo(@"======Observed playerItem status changed to 'AVPlayerStatusReadyToPlay'");
                    [self addScrubberTimer];
                    
                    [self.player play];
                    [self videoDidPlay];
                    break;
                }
                case AVPlayerItemStatusFailed: {
                    NSLogError(@"======Observed playerItem status changed to 'AVPlayerStatusFailed'");
                    AVPlayerItem *playerItem = (AVPlayerItem *)object;
                    [self assetFailedToPrepareForPlayback:playerItem.error];
                    break;
                }
            }
        }
	}
	/* AVPlayer "rate" property value observer. */
	else if (context == SNPlayerViewPlayerRateObservationContext) {
        NSLogInfo(@"======Observed context 'player rate' changed.");
        
        if ([object isKindOfClass:[AVQueuePlayer class]]) {
            AVQueuePlayer *_player = (AVQueuePlayer *)object;
            CGFloat _rate = _player.rate;
//            CGFloat rate = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
            NSLogInfo(@"======Observed playerRate changed to '%f'", _rate);
            
            if (_rate > 0) {
                [self videoDidPlay];
            }
            //Rate=0，表示播放暂停或播放失败
            else {
            }
        }
	}
	/* AVPlayer "currentItem" property observer.
     Called when the AVPlayer replaceCurrentItemWithPlayerItem:
     replacement will/did occur. */
	else if (context == SNPlayerViewPlayerCurrentItemObservationContext) {
        NSLogInfo(@"======Observed context 'current playerItem' changed.");
        
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        NSLogInfo(@"======Current playerItem changed to '%@'", newPlayerItem);
        
        /* Is the new player item null? */
        if (newPlayerItem == (id)[NSNull null]) {
            NSLogError(@"=== null player item...");
        }
        /**
         * Replacement of player currentItem has occurred
         * Set the AVPlayer for which the player layer displays visual output.
         * Specifies that the player should preserve the video’s aspect ratio and fit the video within the layer’s bounds.
         **/
        else {
            NSLogInfo(@"===player item had replaced...");
        }
	}
    else if (context == SNPlayerViewPlaterItemDurationObservationContext) {
        NSLogInfo(@"======Observed context 'player item duration' changed.");
    }
    else {
		[super observeValueForKeyPath:path ofObject:object change:change context:context];
        
        NSLogInfo(@"======Observed other context changed.");
	}
}

#pragma mark - Private
- (void)play {
    if (self.toolBar.playBtnStatus == WSVideoPlayerPlayBtnStatus_Pause) {
        [self.player play];
        return;
    }
    
    if (self.videoModels.count > 0) {
        WSVideoModel *_videoModel = nil;
        if (_selectedChannelIndex >= 0 && _selectedChannelIndex < self.videoModels.count) {
            _videoModel = [self.videoModels objectAtIndex:_selectedChannelIndex];
        } else {
            _videoModel = [self.videoModels objectAtIndex:0];
        }
        [self loadVideoSourceAndReadyToPlay:_videoModel];
    } else {
        [self noVideoSourceToPlay];
    }
}

- (void)pause {
    [self.loadingView stopAnimation];
    [self.player pause];
    [self.toolBar setPlayBtnStatus:WSVideoPlayerPlayBtnStatus_Pause];
    
//    [self generateThumbnail1];
//    [self generateThumbnail2];
}

- (void)tapVideoPlayer {
    BOOL _isPlaylistShown = (self.playlistView.left < self.width);
    if (_isPlaylistShown) {
        [self hidePlaylistView];
        return;
    }
    [self hideOrShowToolbar];
}

- (void)hideToolbar {
    if (!(self.toolBar.hidden)) {
        [self hideOrShowToolbar];
    }
}

- (void)showToolbar {
    if (self.toolBar.hidden) {
        [self hideOrShowToolbar];
    }
}

- (void)hideOrShowToolbar {
    if (!_isFinishedToShowOrHideToolBar) {
        return;
    }
    
    _isFinishedToShowOrHideToolBar = NO;
    if (!(self.toolBar.hidden)) {
        [UIView animateWithDuration:0.3 animations:^{
            self.toolBar.alpha = 0;
        } completion:^(BOOL finished) {
            self.toolBar.hidden = YES;
            self.toolBar.alpha = 1;
            _isFinishedToShowOrHideToolBar = YES;
        }];
    } else {
        self.toolBar.alpha = 0;
        self.toolBar.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.toolBar.alpha = 1;
        } completion:^(BOOL finished) {
            _isFinishedToShowOrHideToolBar = YES;
        }];
    }
}

- (void)hidePlaylistView {
    BOOL _isPlaylistShown = (self.playlistView.left < self.width);
    if (_isPlaylistShown) {
        [UIView animateWithDuration:0.2 animations:^{
            self.playlistView.alpha = 0;
            self.playlistView.left = self.width;
        } completion:^(BOOL finished) {
            self.playlistView.alpha = 1;
            self.playlistView.hidden = YES;
        }];
    }
}

- (void)showPlaylistView {
    BOOL _isPlaylistShown = (self.playlistView.left < self.width);
    if (!_isPlaylistShown) {
        self.playlistView.alpha = 0;
        self.playlistView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.playlistView.alpha = 1;
            self.playlistView.left = self.width-self.playlistView.width;
        }];
    }
}

#pragma mark -
- (void)loadVideoSourceAndReadyToPlay:(WSVideoModel *)videoModel {
    [self.loadingView stopAnimation];
    [self.loadingView startAnimation];
    
    if (self.videoModels.count <=0) {
        [self noVideoSourceToPlay];
        return;
    }

    if (!(videoModel) || videoModel.sources.count <=0) {
        [self noVideoSourceToPlay];
    }
    else {
        [self.assetArray removeAllObjects];
        for (NSString *_playSource in videoModel.sources) {
            AVURLAsset *_asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:_playSource]
                                                     options:@{AVURLAssetPreferPreciseDurationAndTimingKey:[NSNumber numberWithBool:YES]}];
            if (!!_asset) {
                [_assetArray addObject:_asset];
            }
        }

        if (self.assetArray.count > 0) {
            NSLogInfo(@"===Loading first asset...");
            AVURLAsset *_asset      = [_assetArray objectAtIndex:0];
            NSArray *_requestedKeys = [NSArray arrayWithObjects:kTracksKey, kPlayableKey, nil];
            [_asset loadValuesAsynchronouslyForKeys:_requestedKeys completionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self doneLoadingAsset:_asset withKeys:_requestedKeys];
                });
            }];
        } else {
            [self noVideoSourceToPlay];
        }
    }
}

- (void)doneLoadingAsset:(AVAsset *)asset withKeys:(NSArray *)keys {
    //===CHECK IF OK======
    NSLogInfo(@"===Finished to load first asset and check if it's OK.");
	for (NSString *key in keys) {
		NSError *error = nil;
		AVKeyValueStatus status = [asset statusOfValueForKey:key error:&error];
		if (status == AVKeyValueStatusFailed || status == AVKeyValueStatusCancelled) {
            // Error, error
            double delayInSeconds = 1.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self assetFailedToPrepareForPlayback:error];
            });
			return;
		}
	}
    
    if (!asset.playable) {
        /* Generate an error describing the failure. */
		NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
		NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
		NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
								   localizedDescription, NSLocalizedDescriptionKey,
								   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
								   nil];
		NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        /* Display the error to the user. */
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        return;
    }
    NSLogInfo(@"===Finished to check asset and it's OK.");
    //=========
    
    
    //===CREATE PLAYERITEMS
    NSLogInfo(@"===Creating playerItems...");
    // Remove observer from old playerItem and create new one
    for (AVPlayerItem *_playerItem in self.playerItemArray) {
        NSLogInfo(@"=====Removing 'kStatusKey' observer for old playerItem...");
        [_playerItem removeObserver:self forKeyPath:kStatusKey];
    }
    NSLogInfo(@"====Removing all old playerItems in cached array...");
    [self.playerItemArray removeAllObjects];
    // Create player item
    for (AVAsset *_asset in _assetArray) {
        NSLogInfo(@"=====Creating a new playerItem...");
        AVPlayerItem *_playerItem = [AVPlayerItem playerItemWithAsset:_asset];
        if (!!_playerItem) {
            NSLogInfo(@"======Adding 'kStatusKey' observer for new created playerItem...");
            // Observe status, ok -> play
            [_playerItem addObserver:self
                          forKeyPath:kStatusKey
                             options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew)
                             context:SNPlayerViewPlayerItemStatusObservationContext];
            NSLogInfo(@"======Appending new created playerItem into cached array...");
            [self.playerItemArray addObject:_playerItem];
        }
    }
    NSLogInfo(@"===Finished creating playerItems.");
    //=========

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.currentItem];
    
    //===CREATE PLAYER
    NSLogInfo(@"===Creating player...");
    
    // Create the player
    [self.player removeObserver:self forKeyPath:kCurrentItemKey context:SNPlayerViewPlayerCurrentItemObservationContext];
    [self.player removeObserver:self forKeyPath:kRateKey context:SNPlayerViewPlayerRateObservationContext];
    self.player = nil;
    if (!(self.player)) {
        [self setPlayer:[AVQueuePlayer queuePlayerWithItems:self.playerItemArray]];
        NSLogInfo(@"===Finished Creating a new player.");
        
        NSLogInfo(@"===Adding 'kCurrentItem' observer for new created player...");
        /* Observe the AVPlayer "currentItem" property to find out when any
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
         occur.*/
        [self.player addObserver:self
                      forKeyPath:kCurrentItemKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:SNPlayerViewPlayerCurrentItemObservationContext];
        NSLogInfo(@"===Finish adding 'kCurrentItem' observer for new created player...");
        
        NSLogInfo(@"===Adding 'kRateKey' observer for new created player...");
        // Observe rate, play/pause-button?
        [self.player addObserver:self
                      forKeyPath:kRateKey
                         options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew)
                         context:SNPlayerViewPlayerRateObservationContext];
        NSLogInfo(@"===Finish adding 'kRateKey' observer for new created player...");
    }
//    else {
//        NSLogInfo(@"===Player existed, refreshing playerItems in existed player...");
//        AVQueuePlayer *_queuePlayer = (AVQueuePlayer *)(self.player);
//        NSLogInfo(@"===Removing all old player items in player...");
//        [_queuePlayer removeAllItems];
//        NSLogInfo(@"===Finished removing all old player items in player...");
//        for (AVPlayerItem *_playerItem in self.playerItemArray) {
//            NSLogInfo(@"===Inserting new playerItem into existed player...");
//            [_queuePlayer insertItem:_playerItem afterItem:nil];
//        }
//        NSLogInfo(@"===Finished refreshing playerItems in existed player...");
//    }
    
    NSLogInfo(@"===Finished to create player.");
    NSLogInfo(@"===PREPARED TO PLAY >>>");
}

- (void)generateThumbnail1 {
    NSLogInfo(@"===Generating thumbnail image from checked asset.");
    
    AVPlayerItem *_currentPlayerItem = self.player.currentItem;
    if (!!_currentPlayerItem) {
        NSArray *_currentItemTracks = _currentPlayerItem.tracks;
        NSLogInfo(@"===There are %d tracks in currentPlayerItem, %@", _currentItemTracks.count, _currentItemTracks);
        for (AVPlayerItemTrack *_playerItemTrack in _currentItemTracks) {
            AVAssetTrack *_assetTrack = _playerItemTrack.assetTrack;
            NSArray *_playerItemTracks = _assetTrack.asset.tracks;
            NSLogInfo(@"===There arer %d tracks in playerItemAsset, %@", _playerItemTracks.count, _playerItemTracks);
            
            NSArray *_videoTracksInPlayerItemAsset = [_assetTrack.asset tracksWithMediaType:AVMediaTypeVideo];
            NSLogInfo(@"===There are %d video tracks in playerItemAsset, %@", _videoTracksInPlayerItemAsset.count, _videoTracksInPlayerItemAsset);
            
            NSArray *_audioTracksInPlayerItemAsset = [_assetTrack.asset tracksWithMediaType:AVMediaTypeAudio];
            NSLogInfo(@"===There are %d audio tracks in playerItemAsset, %@", _audioTracksInPlayerItemAsset.count, _audioTracksInPlayerItemAsset);
            
            //从视频track中抽取图片
            if ([_assetTrack.mediaType isEqualToString:AVMediaTypeVideo]) {
                AVAsset *_asset = _assetTrack.asset;
                AVAssetImageGenerator *_imageGenerator = [[AVAssetImageGenerator assetImageGeneratorWithAsset:_asset] retain];
                
                Float64 _durationSeconds = CMTimeGetSeconds([_asset duration]);
                CMTime _midPoint = CMTimeMakeWithSeconds(_durationSeconds/2.0, 600);
                NSError *_error = nil;
                CMTime _actualTime;
                
                CGImageRef _halfWayImage = [_imageGenerator copyCGImageAtTime:_midPoint actualTime:&_actualTime error:&_error];
                if (_halfWayImage != NULL) {
                    NSString *_actualTimeString = (NSString *)CMTimeCopyDescription(NULL, _actualTime);
                    NSString *_requestedTimeString = (NSString *)CMTimeCopyDescription(NULL, _midPoint);
                    NSLogInfo(@"Got halfWayImage: Asked for %@, got %@", _requestedTimeString, _actualTimeString);
                }
                if (!!_error) {
                    NSLogInfo(@"===Error ocurred in generating thumbnail: %@", _error);
                }
                
                [_imageGenerator release];
                _imageGenerator = nil;
            }
        }
    }
    NSLogInfo(@"===Finish generating thumbnail image from checked asset.");
}

- (void)generateThumbnail2 {
    NSLogInfo(@"===Generating thumbnail image from checked asset.");
    
    NSArray *_playerItemTracks = self.player.currentItem.tracks;
    if (_playerItemTracks.count > 0) {
        AVPlayerItemTrack *_playerItemTrack = [_playerItemTracks objectAtIndex:0];
        AVAssetImageGenerator *_imageGenerator = [[AVAssetImageGenerator assetImageGeneratorWithAsset:_playerItemTrack.assetTrack.asset] retain];
        [_imageGenerator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:self.player.currentTime]]
                                              completionHandler: ^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {
                                                  NSLogInfo(@"actual got image at time:%f", CMTimeGetSeconds(actualTime));
                                                  if (image) {
                                                      UIImage *img = [UIImage imageWithCGImage:image];
                                                      NSData *_imgData =  UIImageJPEGRepresentation(img, 1.0f);
                                                      
                                                      CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
                                                      NSString *UDID = [(NSString *)CFUUIDCreateString (kCFAllocatorDefault,uuidRef) autorelease];
                                                      CFRelease(uuidRef);
                                                      
                                                      NSArray  *paths                 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                                      NSString *documentsDirectory	= [paths objectAtIndex:0];
                                                      NSString *_filePath            = [documentsDirectory stringByAppendingPathComponent:UDID];

                                                      [_imgData writeToFile:_filePath atomically:YES];
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          self.poster.image = img;
                                                          self.poster.hidden = NO;
                                                      });
                                                      
//                                                      [CATransaction begin];
//                                                      [CATransaction setDisableActions:YES];
////                                                      [layer setContents:(id)image];
//                                                      
//                                                      //UIImage *img = [UIImage imageWithCGImage:image];
//                                                      //UIImageWriteToSavedPhotosAlbum(img, self, nil, nil);
//                                                      
//                                                      [CATransaction commit];
                                                  }
                                              }
         ];
        
        [_imageGenerator release];
        _imageGenerator = nil;
    }
    
    NSLogInfo(@"===Finish generating thumbnail image from checked asset.");
}

#pragma mark -
- (void)assetFailedToPrepareForPlayback:(NSError *)error {
    NSLogError(@"==assetFailedToPrepareForPlayback: %@", [error localizedDescription]);
    
    [self removePlayerTimeObserver];
    [self syncScrubber];
    
    [self.player setRate:0];
    [self videoPlayError:error];
}

- (void)videoPlayError:(NSError *)error {
    NSLogError(@"ERROR OCCURED WHILE PLAYING VIDEO, errorCode:%d, errorDescription:%@, playerStatus:%d, playerRate:%f playerItemStatus:%d ...",
               error.code, error.localizedDescription, self.player.status, self.player.rate, self.player.currentItem.status);
    
    [self hidePlaylistView];
    [self.msgBox pushMsg:@"播放失败，稍后重试！"];
    NSLogError(@"播放失败，稍后重试！");
    
    self.poster.hidden = NO;
    [self.toolBar setPlayBtnStatus:WSVideoPlayerPlayBtnStatus_Stop];
    [self.loadingView stopAnimation];
    
    if ([_delegate respondsToSelector:@selector(videoPlayError:)]) {
        [_delegate videoPlayError:error];
    }
    
//    playBtn;
//    _placehoderView.hidden = NO;
//    _placehoderView.alpha = 1;
//    [loadingView stopAnimation];
}

- (void)videoDidPlay {
    [self hideToolbar];
    [self hidePlaylistView];
    
    if ([_delegate respondsToSelector:@selector(videoDidPlay)]) {
        [_delegate videoDidPlay];
    }
    
    self.poster.hidden = YES;
    [self.toolBar setPlayBtnStatus:WSVideoPlayerPlayBtnStatus_Playing];
    [self.loadingView stopAnimation];
    
//    playBtn;
//    _placehoderView.alpha = 1;
//    [loadingView stopAnimation];
}

#pragma mark -
- (void)noVideoSourceToPlay {
    [self hidePlaylistView];
    [self.msgBox pushMsg:@"无数据可播放!"];
    NSLogWarning(@"无数据可播放!");
    [self.toolBar setPlayBtnStatus:WSVideoPlayerPlayBtnStatus_Stop];
    [self.loadingView stopAnimation];
}

/* ---------------------------------------------------------
 **  Methods to handle manipulation of the movie scrubber control
 ** ------------------------------------------------------- */

/* Requests invocation of a given block during media playback to update the movie scrubber control. */
-(void)addScrubberTimer {
	double interval = .1f;
	
	CMTime playerDuration = [self playerItemDuration];
	if (CMTIME_IS_INVALID(playerDuration))
	{
        NSLogError(@"===Invalid playerDuration.");
		return;
	}
	double duration = CMTimeGetSeconds(playerDuration);
	if (isfinite(duration)) {
		CGFloat width = CGRectGetWidth([self.toolBar.progressBar.progressSlider bounds]);
		interval = 0.5f * duration / width;
        
        //Non live
        [self.toolBar.progressBar initTimeLabelTextToNonLive];
	} else {
        //Live
        [self.toolBar.progressBar initTimeLabelTextToLive];
    }
    
	/* Update the scrubber during normal playback. */
	_mTimeObserver = [[self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                                queue:NULL /* If you pass NULL, the main queue is used. */
                                                           usingBlock:^(CMTime time) {
                          [self syncScrubber];
                      }] retain];
    
    //Observe video will end
    Float64 durationSeconds = duration;
    CMTime _alertTime = CMTimeMakeWithSeconds(durationSeconds-10, 1);
    NSArray *times = @[[NSValue valueWithCMTime:_alertTime]];
    _boundaryTimeObserver = [[self.player addBoundaryTimeObserverForTimes:times queue:NULL usingBlock:^{
        NSLogWarning(@"===Video will end in 10 seconds...");
    }] retain];
}

/* Set the scrubber based on the player current time. */
- (void)syncScrubber {
	CMTime playerDuration = [self playerItemDuration];
	if (CMTIME_IS_INVALID(playerDuration)) {
        self.toolBar.progressBar.progressSlider.minimumValue = 0.0f;
		return;
	}
    
	double duration = CMTimeGetSeconds(playerDuration);
	if (isfinite(duration)) {
		double time = CMTimeGetSeconds([self.player currentTime]);
        [self.toolBar.progressBar updateToCurrentTime:time duration:duration];
	}
}

- (CMTime)playerItemDuration {
	AVPlayerItem *playerItem = [self.player currentItem];
	if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
        /*
         NOTE:
         Because of the dynamic nature of HTTP Live Streaming Media, the best practice
         for obtaining the duration of an AVPlayerItem object has changed in iOS 4.3.
         Prior to iOS 4.3, you would obtain the duration of a player item by fetching
         the value of the duration property of its associated AVAsset object. However,
         note that for HTTP Live Streaming Media the duration of a player item during
         any particular playback session may differ from the duration of its asset. For
         this reason a new key-value observable duration property has been defined on
         AVPlayerItem.
         
         See the AV Foundation Release Notes for iOS 4.3 for more information.
         */
        
		return([playerItem duration]);
	}
	
	return(kCMTimeInvalid);
}

/* Cancels the previously registered time observer. */
-(void)removePlayerTimeObserver {
	if (_mTimeObserver) {
		[self.player removeTimeObserver:_mTimeObserver];
		[_mTimeObserver release];
		_mTimeObserver = nil;
	}
    
    if (_boundaryTimeObserver) {
        [self.player removeTimeObserver:_boundaryTimeObserver];
        [_boundaryTimeObserver release];
        _boundaryTimeObserver = nil;
    }
}

/* Called when the player item has played to its end time. */
- (void)playerItemDidReachEnd:(NSNotification *)notification {
	/* After the movie has played to its end time, seek back to time zero
     to play it again. */
    [self.player seekToTime:kCMTimeZero];
    self.poster.hidden = NO;
    [self.toolBar setPlayBtnStatus:WSVideoPlayerPlayBtnStatus_Stop];
    [self.toolBar.progressBar initTimeLabelTextToNonLive];
    self.toolBar.progressBar.progressSlider.enabled = NO;
    [self showToolbar];
    
    NSLogInfo(@"===playerItem play end.");
}

@end