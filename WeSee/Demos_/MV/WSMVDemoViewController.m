//
//  WSMVDemoViewController.m
//  WeSee
//
//  Created by handy wang on 8/14/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSMVDemoViewController.h"
#import "WSMVVideoPlayerView.h"

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
    
    [self.playerView stop];
    self.playerView.delegate = nil;
    self.playerView = nil;
    self.playerView = [[[WSMVVideoPlayerView alloc] initWithFrame:self.view.bounds] autorelease];
    self.playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.playerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
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
