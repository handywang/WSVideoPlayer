//
//  WSWebVideoViewController.m
//  WeSee
//
//  Created by handy on 8/13/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSWebVideoViewController.h"

@interface WSWebVideoViewController ()
@property (nonatomic, assign)UIWebView *webView;
@end

@implementation WSWebVideoViewController

#pragma mark - Lifecycle
- (void)loadView {
    _webView = [[[UIWebView alloc] init] autorelease];
    _webView.delegate = self;
    self.view = _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *_filePath = [[NSBundle mainBundle] pathForResource:@"web_video" ofType:@"html"];
    NSString *_content = [NSString stringWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:_content baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [self.webView loadHTMLString:@"" baseURL:nil];
    self.webView.delegate = nil;
    [self.webView stopLoading];
    _webView = nil;
}

- (void)dealloc {
    [self.webView loadHTMLString:@"" baseURL:nil];
    self.webView.delegate = nil;
    [self.webView stopLoading];
    _webView = nil;
    [super dealloc];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *_filePath = [[NSBundle mainBundle] pathForResource:@"web_video" ofType:@"mp4"];
    NSURL *_fileURL = [NSURL fileURLWithPath:_filePath];
    NSString *_videoHTML = [NSString stringWithFormat:@"<video width=\"100%%\" height=\"400\" controls=\"controls\" autoplay=\"true\"><br/><source src=\"%@\" type=\"video/mp4\"><br/></video>",
                            [_fileURL absoluteString]];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"renderVideo('%@');", _videoHTML]];
    
    NSString *_videoSourceCode = [_videoHTML stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\\n"];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"renderVideoSourceCode('%@');", _videoSourceCode]];
}

@end