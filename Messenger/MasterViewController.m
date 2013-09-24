//
//  MasterViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-10.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MasterViewController.h"
#import "DetailViewController.h"

#import "JSONModelLib.h"
#import "UsersFeed.h"
//#import "OxwallFeed.h"
#import "HUD.h"

@interface MasterViewController () {
    UsersFeed* _feed;
    UsersModel* usersModel;
    NSArray* usersArr;
    
}

@end

@implementation MasterViewController {
    UsersFeed * _feed;
    NSArray *searchResults;
    NSArray *searchResultsAvatar;
    // NSArray* usersArr;
    NSDictionary* json;
    
}
@synthesize usersArr, json;

- (void)viewDidLoad
{
    [super viewDidLoad];
    usersArr = [[NSArray alloc]init];
    json = [[NSDictionary alloc]init];
    
    
    // Title
    self.title = @"Oxwall search";
    
    [self getFeed:@"t"];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchText];
    
    
   
    searchResults = [[usersArr valueForKey:@"realname"] filteredArrayUsingPredicate:resultPredicate];
   // searchResultsAvatar = [usersArr valueForKey:@"avatar"];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)getFeed:(NSString*)term {
    
    NSLog(@"Searching for '%@' ...", term);
    //URL escape the term
    
    
    //make HTTP call
    NSString* searchCall = [NSString stringWithFormat:@"http://cloudshare.se/webservice/members.php?search=%@", term];
    
    [JSONHTTPClient getJSONFromURLWithString: searchCall
                                  completion:^(NSDictionary *json, JSONModelError *err) {
                                      
                                      //got JSON back
                                      NSLog(@"Got JSON from web: %@", json);
                                      
                                      if (err) {
                                          [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:[err localizedDescription]
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Close"
                                                            otherButtonTitles: nil] show];
                                          return;
                                      }
                                      
                                      //initialize the models
                                      usersArr = [UsersModel arrayOfModelsFromDictionaries:
                                                  json[@"posts"]
                                                  ];
                                      NSLog(@"videos: %@", usersArr);
                                      if (usersArr) NSLog(@"Loaded successfully models");
                                      [self.tableView reloadData];
                                      
                                  }];
    
    
    
}

#pragma mark - table methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        
        
        return usersArr.count;
        
    }
    
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UsersModel* user = usersArr[indexPath.row];
    //user = _feed.posts[indexPath.row];
    static NSString *simpleTableIdentifier = @"SearchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
    }
    
    // Here we use the new provided setImageWithURL: method to load the web image
    
    
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
        //[cell.imageView setImageWithURL:[[searchResults objectAtIndex:indexPath.row] valueForKey:@"avatar" ]
        //               placeholderImage:[UIImage imageNamed:@"missingAvatar"]];

    } else {
        cell.textLabel.text = [[usersArr objectAtIndex:indexPath.row] valueForKey:@"realname"];
        //[cell.imageView setImageWithURL:[[usersArr objectAtIndex:indexPath.row] valueForKey:@"avatar"]
        //               placeholderImage:[UIImage imageNamed:@"missingAvatar"]];
    }
    
    
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Implement method for selecting users
    
    // [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    // [self performSegueWithIdentifier:@"profile" sender:self];
    
    
}



@end
