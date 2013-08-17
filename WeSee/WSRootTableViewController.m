//
//  WSRootTableViewController.m
//  WeSee
//
//  Created by handy wang on 8/13/13.
//  Copyright (c) 2013 handy. All rights reserved.
//

#import "WSRootTableViewController.h"
#import "WSAVDemoViewController.h"
#import "WSWebVideoViewController.h"
#import "WSMVDemoViewController.h"

@interface WSRootTableViewController ()
@property (nonatomic, retain)NSArray *data;
@end

@implementation WSRootTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.data = [NSArray arrayWithObjects:@"UIWebView Video Demo", @"MPMoviePlayer Video Demo", @"AVFoundatation Video Demo", nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self.data = nil;
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell= [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            WSWebVideoViewController *_webVideo = [[WSWebVideoViewController alloc] init];
            [self.navigationController pushViewController:_webVideo animated:YES];
            [_webVideo release];
            _webVideo = nil;
            break;
        }
        case 1: {
            WSMVDemoViewController *_mvDemo = [[WSMVDemoViewController alloc] init];
            [self.navigationController pushViewController:_mvDemo animated:YES];
            [_mvDemo release];
            _mvDemo = nil;
            break;
        }
        case 2: {
            WSAVDemoViewController *_avDemo = [[WSAVDemoViewController alloc] init];
            [self.navigationController pushViewController:_avDemo animated:YES];
            [_avDemo release];
            _avDemo = nil;
            break;
        }
        default: {
            break;
        }
    }
}

@end