//
//  WSMVDemoViewController.m
//  WeSee
//
//  Created by handy wang on 8/14/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSMVDemoViewController.h"
#import "WSMVVideoPlayerView.h"
#import "WSVideoModel.h"
#import "JSONKit.h"

@interface WSMVDemoViewController ()
@property (nonatomic, retain)WSMVVideoPlayerView *playerView;
@end

@implementation WSMVDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    NSString *_playlistJSON = @"[\
    {\"name\":\"MP3\", \"source\":\"http://nj.baidupcs.com/file/37050501dfb9a1778e3277a480248416?xcode=3f6893adf491953792290b87d65f04bb3372e38b42946605&fid=1963245933-250528-3102797599&time=1376896497&sign=FDTAXER-DCb740ccc5511e5e8fedcff06b081203-UPumqGbZt45cqI5Cvcncw8l4mzk%3D&to=nb&fm=N,B,U&expires=8h&rt=pr&r=285551615&logid=1821045146&fn=%E4%B8%8B%E9%9B%A8%E6%97%B6%E4%BD%A0%E5%9C%A8%E5%93%AA%E9%87%8C.mp3\"}\
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
    
    [self.playerView stop];
    self.playerView.delegate = nil;
    self.playerView = nil;
    self.playerView = [[[WSMVVideoPlayerView alloc] initWithFrame:self.view.bounds] autorelease];
    [self.playerView setVideoModels:_videoModels];
    self.playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.playerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
     
- (void)dealloc {
    [self.playerView stop];
    self.playerView.delegate = nil;
    self.playerView = nil;
    
    [super dealloc];
}

@end
