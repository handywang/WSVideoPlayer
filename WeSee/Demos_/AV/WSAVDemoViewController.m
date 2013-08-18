//
//  WSAVDemoViewController.m
//  WeSee
//
//  Created by handy on 8/13/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSAVDemoViewController.h"
#import "WSAVVideoPlayer.h"
#import "JSONKit.h"
#import "UIViewAdditions.h"

@interface WSAVDemoViewController ()
@property (nonatomic, retain)WSAVVideoPlayer *videoPlayer;
@end

@implementation WSAVDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //Mp4:(
    //     "http://data.vod.itc.cn/?new=/190/139/Sw0NUHpzEQLrAisgiAUXn4.mp4&ch=tv&cateCode=115101;115102;115103;115104&plat=null",
    //     "http://data.vod.itc.cn/?new=/169/47/ToEJNSjblmkTVzuVJNGMY2.mp4&ch=tv&cateCode=115101;115102;115103;115104&plat=null",
    //     "http://data.vod.itc.cn/?new=/192/177/glAkNljiS00rDRqTYANff6.mp4&ch=tv&cateCode=115101;115102;115103;115104&plat=null",
    //     "http://data.vod.itc.cn/?new=/168/152/2NnTSIDGRoCC0ZMw4b5x14.mp4&ch=tv&cateCode=115101;115102;115103;115104&plat=null",
    //     "http://data.vod.itc.cn/?new=/71/228/TeNLOlxGWmUG2BNeRoO995.mp4&ch=tv&cateCode=115101;115102;115103;115104&plat=null"
    //     )
    
    NSString *_playlistJSON = @"[\
    {\"name\":\"MP4\", \"source\":\"http://data.vod.itc.cn/?new=/190/139/Sw0NUHpzEQLrAisgiAUXn4.mp4&ch=tv&cateCode=115101;115102;115103;115104&plat=null\"},\
    {\"name\":\"CCTV1综合\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=cctv1&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV2财经\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=cctv2&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV3综艺\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=cctv3&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV-4亚洲\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=cctv4&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV5体育\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=cctv5_800&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV6电影\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=cctv6&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV7军事农业\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=cctv7&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV8电视剧\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=cctv8&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV9纪录\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=cctv9&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV10科教\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=cctv10&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV11戏曲\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=cctv11&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV12社会与法\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=cctv12&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV13新闻\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=cctvnew&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV14少儿\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=cctvshaoer&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV15音乐\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=cctvmusic&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV第一剧场\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=dyjc&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV风云音乐\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=fyyy&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV风云足球\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=fyzq&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV国防军事\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=guofangjunshi&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV怀旧剧场\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=hjjc&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV世界地理\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=shijiedili&tag=live&ext=m3u8&sign=live_ipad\"},\
    {\"name\":\"CCTV央视精品\", \"source\":\"http://biz.vsdn.tv380.com/playlive.php?5B63686E5D445830303030303034367C343436367C317C313030307C4C4235302E434E7C687474707C74735B2F63686E5DVSDNSOOONERCOM00\"},\
    {\"name\":\"CCTV央视台球\", \"source\":\"http://ims.veryhd.net/ty/ts.php?tsid=464691\"},\
    {\"name\":\"搜狐直播测试\", \"source\":\"http://gslb.tv.sohu.com/live?cid=36&sig=4X5THMMhit-_C-NndnlfVw..&type=hls\"},\
    {\"name\":\"NickJr\", \"source\":\"http://fw01.livem3u8.me.totiptv.com/live/2b72986be9314c139db95f6098d1c413.m3u8?bitrate=800\"},\
    {\"name\":\"Channel_3\", \"source\":\"http://fw01.livem3u8.me.totiptv.com/live/8bad9f20ff2246b894eddced10dcfdeb.m3u8?bitrate=800\"},\
    {\"name\":\"卡酷动画\", \"source\":\"http://live.gslb.letv.com/gslb?stream_id=bjkaku&tag=live&ext=m3u8&sign=live_ipad\"}\
    ]";
    //    {\"name\":\"\", \"source\":\"\"}\
    
    id _parsedData = [_playlistJSON objectFromJSONString];
    NSMutableArray *_videoModels = [NSMutableArray array];
    if ([_parsedData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *_tvChannel in _parsedData) {
            NSString *_name     = [_tvChannel valueForKey:@"name"];
            NSString *_poster   = @"default_poster.jpg";
            NSString *_source   = [_tvChannel valueForKey:@"source"];
            
            WSVideoModel *_videoModel       = [[WSVideoModel alloc] init];
            _videoModel.title               = _name;
            _videoModel.poster              = _poster;
            _videoModel.sources             = [NSMutableArray arrayWithObject:_source];
            [_videoModels addObject:_videoModel];
            [_videoModel release];
            _videoModel = nil;
        }
    }
    
    [self.videoPlayer stop];
    self.videoPlayer.delegate = nil;
    self.videoPlayer = nil;
    _videoPlayer = [[WSAVVideoPlayer alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _videoPlayer.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    [_videoPlayer setVideoModels:_videoModels];
    [self.view addSubview:_videoPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self.videoPlayer stop];
    self.videoPlayer.delegate = nil;
    self.videoPlayer = nil;
    [super dealloc];
}

@end