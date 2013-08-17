//
//  WSRootViewController.m
//  WeSee
//
//  Created by handy on 7/24/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSRootViewController.h"
#import "WSRootTableViewController.h"

@interface WSRootViewController () {
}
@end

@implementation WSRootViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Demos";
        WSRootTableViewController *_tableVC = [[[WSRootTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        [self pushViewController:_tableVC animated:NO];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Autorotation
//NS_DEPRECATED_IOS(2_0, 6_0);
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;//UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

//New Autorotation support.
//NS_AVAILABLE_IOS(6_0);
- (BOOL)shouldAutorotate {
    return YES;
}

//NS_AVAILABLE_IOS(6_0);
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

//NS_AVAILABLE_IOS(6_0);
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

@end
