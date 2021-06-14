//
//  ViewControllerLevelProgressChart.m
//  Progress
//
//  Created by Sudhir Sawarkar on 11/15/15.
//  Copyright © 2015 Catamaran Labs. All rights reserved.
//

#import "ViewControllerLevelProgressChart.h"
#import <Parse/Parse.h>

@interface ViewControllerLevelProgressChart ()
@property (weak, nonatomic) IBOutlet UIButton *button_back;

@end

@implementation ViewControllerLevelProgressChart

- (void)viewDidLoad
{
  [super viewDidLoad];

  UIImage *seeResearch = [UIImage imageNamed:@"images/carousel/researchButton.png"];
  [self.button_back setBackgroundImage:seeResearch forState:UIControlStateNormal];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
    
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aCoder
{
  self = [super initWithCoder:aCoder];
  
  if (self)
  {
    // The className to query on
    self.parseClassName = @"stageAssemble";
        
    // The key of the PFObject to display in the label of the default cell style
    self.textKey = @"playerName";
        
    // Whether the built-in pull-to-refresh is enabled
    //self.pullToRefreshEnabled = YES;
        
    // Whether the built-in pagination is enabled
    self.paginationEnabled = NO;
  
    // limit object per page
    self.objectsPerPage = 10;
  }
  
  return self;
}

- (PFQuery *)queryForTable
{
  PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
  [query orderByDescending:@"playerName"];
  query.limit = 10;
//  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
//    // objects is the top 10 scores in the table
//    
//  }];
  return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
  static NSString *simpleTableIdentifier = @"Cell";
    
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
  }
  
  UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
  nameLabel.text = [object objectForKey:@"playerName"];
    
  UILabel *nameLabel1 = (UILabel*) [cell viewWithTag:102];
  nameLabel1.text = [NSString stringWithFormat:@"%@", [object objectForKey:@"totalResponses"]];
  
  return cell;
}


@end
