//
//  ViewControllerLevelHome.m
//  Progress
//
//  Created by Sudhir Sawarkar on 11/7/15.
//  Copyright © 2015 Catamaran Labs. All rights reserved.
//

#import "ViewControllerLevelHome.h"
#import "ViewControllerLevelOneOne.h"
#import "ViewControllerLevelTwoOne.h"
#import "ViewControllerLevelThreeOne.h"
#import "DataStoreConfiguration.h"
#import <Parse/Parse.h>

@interface ViewControllerLevelHome ()

@property (weak, nonatomic) IBOutlet UIImageView *image_profilePic;
@property (weak, nonatomic) IBOutlet UIImageView *image_levelDescription;
@property (weak, nonatomic) IBOutlet UIImageView *image_trophyCase;
@property (weak, nonatomic) IBOutlet UIImageView *image_progressChart;
@property (weak, nonatomic) IBOutlet UIImageView *image_stage1;
@property (weak, nonatomic) IBOutlet UIImageView *image_stage2;
@property (weak, nonatomic) IBOutlet UIImageView *image_stage3;
@property (weak, nonatomic) IBOutlet UIImageView *image_stage4;
@property (weak, nonatomic) IBOutlet UIImageView *image_stage5;

@property (weak, nonatomic) IBOutlet UILabel     *label_playerNameEntered;

@property (weak, nonatomic) IBOutlet UILabel *label_lifetimeGlobalRank;
@property (weak, nonatomic) IBOutlet UILabel *label_lifetimeTotalPuzzles;
@property (weak, nonatomic) IBOutlet UILabel *label_lifetimeTotalCorrectPuzzles;
@property (weak, nonatomic) IBOutlet UILabel *label_levelTotalPuzzles;
@property (weak, nonatomic) IBOutlet UILabel *label_levelTotalCorrectPuzzles;
@property (weak, nonatomic) IBOutlet UILabel *label_levelAverageResponseTime;

@property (weak, nonatomic) IBOutlet UIButton *button_start;
@property (weak, nonatomic) IBOutlet UIButton *button_stage1;
@property (weak, nonatomic) IBOutlet UIButton *button_stage2;
@property (weak, nonatomic) IBOutlet UIButton *button_stage3;

@end

@implementation ViewControllerLevelHome

@synthesize lvl_home_inputUserName;
@synthesize lvl_home_levelNumber;

- (void) viewDidAppear:(BOOL)animated
{
  [self getPlayerName];
}

- (void) getPlayerLifetimeStats
{
  if (self.lvl_home_inputUserName == (id)[NSNull null]
      || self.lvl_home_inputUserName.length == 0
      || [self.lvl_home_inputUserName isEqualToString:DEFAULT_PLAYER_NAME_STR])
  {
    // incorrect username
    return;
  }
  
  // Get lifetime total puzzles
  [PFCloud callFunctionInBackground:@"getPlayerLifetimeTotalPuzzles" withParameters:@{@"playerName":self.lvl_home_inputUserName} block:^(id object, NSError *error){
    if (!error){
      NSLog(@"Lifetime Puzzles %@", object);
      self.label_lifetimeTotalPuzzles.text = [NSString stringWithFormat:@"%@", object];
    }
  }];
  
  // Get lifetime total correct puzzles
  [PFCloud callFunctionInBackground:@"getPlayerLifetimeTotalCorrectPuzzles" withParameters:@{@"playerName":self.lvl_home_inputUserName} block:^(id object, NSError *error){
    if (!error){
      NSLog(@"Lifetime Correct Puzzles %@", object);
      self.label_lifetimeTotalCorrectPuzzles.text = [NSString stringWithFormat:@"%@", object];
    }
  }];
  
  // updateGlobalRank
  [PFCloud callFunctionInBackground:@"updatePlayerGlobalRank" withParameters:@{@"playerName":self.lvl_home_inputUserName} block:^(id object, NSError *error){
    if (!error){
      NSLog(@"Update Rank %@", object);
      //self.label_lifetimeTotalCorrectPuzzles.text = [NSString stringWithFormat:@"%@", object];
    }
  }];
  
  // getGlobalRank
  [PFCloud callFunctionInBackground:@"getPlayerGlobalRank" withParameters:@{@"playerName":self.lvl_home_inputUserName} block:^(id object, NSError *error){
    if (!error){
      NSLog(@"Get Global Rank %@", object);
      self.label_lifetimeGlobalRank.text = [NSString stringWithFormat:@"%@", object];
    }
  }];
}

- (void) getPlayerName
{
  // retrieve previously stored playerName from local memory after the app starts
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  self.lvl_home_inputUserName = [defaults objectForKey:@"savedPlayerName"];
  
  // Check to see, if name present
  if (self.lvl_home_inputUserName == (id)[NSNull null]
      || self.lvl_home_inputUserName.length == 0)
  {
    self.button_start.enabled = NO;
    [self tapProfilePicDetected];
  }
  else
  {
    self.label_playerNameEntered.text = self.lvl_home_inputUserName;
    self.button_start.enabled = YES;
    self.lvl_home_levelNumber = 1;
    [self getPlayerLifetimeStats];
    [self highlightButtonBorder:1];
    [self stageActivate:1];
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self loadHomeScreenImages];
  
  //DONGcode - thin, white borders
  [[self.button_stage1 layer] setBorderWidth:1.0f];
  [[self.button_stage1 layer] setBorderColor:[UIColor whiteColor].CGColor];
  
  [[self.button_stage2 layer] setBorderWidth:1.0f];
  [[self.button_stage2 layer] setBorderColor:[UIColor whiteColor].CGColor];
  
  [[self.button_stage3 layer] setBorderWidth:1.0f];
  [[self.button_stage3 layer] setBorderColor:[UIColor whiteColor].CGColor];
  
  // Player Name User Input
  UITapGestureRecognizer *profilePicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfilePicDetected)];
  profilePicTap.numberOfTapsRequired = 1;
  [self.image_profilePic setUserInteractionEnabled:YES];
  [self.image_profilePic addGestureRecognizer:profilePicTap];
}

-(void)tapProfilePicDetected
{
  //Creates the alert box
  UIAlertController *alertController = [UIAlertController
                                        alertControllerWithTitle:DEFAULT_PLAYER_NAME_STR
                                        message:@"Enter player name"
                                        preferredStyle:UIAlertControllerStyleAlert];
  //Adds a text field to the alert box
  [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
   {
     //textField.placeholder = NSLocalizedString(@"Input name here", @"Fullname");
     textField.placeholder = @"Input name here";
   }];
  
  [self presentViewController:alertController animated:YES completion:nil];
  //Creates a button with actions to perform when clicked
  UIAlertAction *SaveAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Save",@"Save Action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                 //Stores what has been inputted into the NSString Fullname
                                 UITextField * textField = alertController.textFields.firstObject;
                                 
                                 NSLog(@"Entered Name: %@", textField.text);
                                 
                                 if ((textField.text != (id)[NSNull null]
                                      && textField.text.length != 0 )
                                     && ![textField.text isEqualToString:DEFAULT_PLAYER_NAME_STR] )
                                 {
                                   // if input string length is more than 15, restrict to 15
                                   if (textField.text.length > 15)
                                   {
                                     textField.text = [textField.text substringToIndex:15];
                                   }
                                   
                                   self.lvl_home_inputUserName = textField.text;
                                   self.label_playerNameEntered.text = textField.text;
                                   NSLog(@"No player name found, saving new player: %@", textField.text);
                                   // save name is local memory so that name persists
                                   NSUserDefaults *testing = [NSUserDefaults standardUserDefaults];
                                   [testing setValue:textField.text forKey:@"savedPlayerName"];
                                   [testing synchronize];
                                   self.button_start.enabled = YES;
                                 }
                               }];
  
  [alertController addAction:SaveAction];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) loadHomeScreenImages
{
  self.image_profilePic.image       = [UIImage imageNamed:@"images/level_home/profilePic.png"];
  self.image_levelDescription.image = [UIImage imageNamed:@"images/level_home/levelImage_1.png"];
}

- (void) queryBackendForDetails
{
  PFQuery *query = [PFQuery queryWithClassName:@"stageAssemble"];
  [query whereKey:@"playerName" equalTo:self.lvl_home_inputUserName];
  //[query whereKey:@"levelPlayed" equalTo:@(11)];
  //[query selectKeys:@[@"totalResponses"]];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
   {
     if (!error)
     {
       NSMutableArray *lifetime_total_rsponses_array = [NSMutableArray arrayWithCapacity:objects.count];
       NSMutableArray *lifetime_total_incorrect_array = [NSMutableArray arrayWithCapacity:objects.count];
       
       int sum = 0,
       sum1 = 0;
       
       for (PFObject *obj in objects)
       {
         [lifetime_total_rsponses_array addObject:[obj objectForKey:@"totalResponses"]];
         [lifetime_total_incorrect_array addObject:[obj objectForKey:@"totalResponsesWrong"]];
       }
       
       for (NSNumber *n in lifetime_total_rsponses_array)
       {
         sum += [n doubleValue];
       }
       
       for (NSNumber *n in lifetime_total_incorrect_array)
       {
         sum1 += [n doubleValue];
       }
       
       NSString * printTimer = [NSString stringWithFormat:@"%d", sum];
       self.label_lifetimeTotalPuzzles.text = printTimer;
       
       NSString * printTimer1 = [NSString stringWithFormat:@"%d", sum - sum1];
       self.label_lifetimeTotalCorrectPuzzles.text = printTimer1;
       
       NSLog(@"%d %d",sum, sum1);
     }
     else
     {
       NSLog(@"Faildedddddddddddddddddddddd");
     }
   }
   ];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"segue_levelHomeToLevelOneOne"])
  {
    ViewControllerLevelOneOne *vc = (ViewControllerLevelOneOne *)segue.destinationViewController;
    vc.lvl_recvUserName = self.lvl_home_inputUserName;
  }
  else if ([segue.identifier isEqualToString:@"segue_levelHomeToLevelTwoOne"])
  {
    ViewControllerLevelTwoOne *vc = (ViewControllerLevelTwoOne *)segue.destinationViewController;
    vc.lvl_recvUserName = self.lvl_home_inputUserName;
  }
  else if ([segue.identifier isEqualToString:@"segue_levelHomeToLevelThreeOne"])
  {
    ViewControllerLevelThreeOne *vc = (ViewControllerLevelThreeOne *)segue.destinationViewController;
    vc.lvl_recvUserName = self.lvl_home_inputUserName;
  }
}

- (IBAction)button_stage1:(id)sender
{
  self.lvl_home_levelNumber = 1;
  [self highlightButtonBorder:1];
  [self stageActivate:1];
}

- (IBAction)button_stage2:(id)sender
{
  self.lvl_home_levelNumber = 2;
  [self highlightButtonBorder:2];
  [self stageActivate:2];
}

- (IBAction)button_stage3:(id)sender
{
  self.lvl_home_levelNumber = 3;
  [self highlightButtonBorder:3];
  [self stageActivate:3];
}
- (IBAction)button_start:(id)sender
{
  if (self.lvl_home_levelNumber == 3)
  {
    [self performSegueWithIdentifier:@"segue_levelHomeToLevelThreeOne" sender:sender];
    ViewControllerLevelThreeOne *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelThreeOne"];
    [self presentViewController:vc animated:YES completion:nil];
  }
  if (self.lvl_home_levelNumber == 2)
  {
    [self performSegueWithIdentifier:@"segue_levelHomeToLevelTwoOne" sender:sender];
    ViewControllerLevelTwoOne *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelTwoOne"];
    [self presentViewController:vc animated:YES completion:nil];
  }
  else // defualt (self.lvl_home_levelNumber == 1)
  {
    [self performSegueWithIdentifier:@"segue_levelHomeToLevelOneOne" sender:sender];
    ViewControllerLevelOneOne *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelOneOne"];
    [self presentViewController:vc animated:YES completion:nil];
  }
}

- (void) highlightButtonBorder: (int) button
{
  if (button == 3)
  {
    // set start button title
    [self.button_start setTitle:@"Level III Start" forState:UIControlStateNormal];
    // set desc image
    self.image_levelDescription.image = [UIImage imageNamed:@"images/level_home/levelImage_3.png"];
    
    // DONGcode - change button 3 background to light grey
    [[self.button_stage3 layer] setBackgroundColor:[UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1].CGColor];
    
    // DONGcode - change button 2 background to dark grey
    [[self.button_stage2 layer] setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1].CGColor];
    
    // DONGcode - change button 1 background
    [[self.button_stage1 layer] setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1].CGColor];
    
    
    /* highlight button 3 border
     [[self.button_stage3 layer] setBorderWidth:1.0f];
     [[self.button_stage3 layer] setBorderColor:[UIColor whiteColor].CGColor];
     // unhighlight button 2 border
     self.button_stage2.layer.borderWidth = 1.0f;
     // unhighlight button 1 border
     self.button_stage1.layer.borderWidth = 1.0f;
     */
  }
  else if (button == 2)
  {
    // set start button title
    [self.button_start setTitle:@"Level II Start" forState:UIControlStateNormal];
    // set desc image
    self.image_levelDescription.image = [UIImage imageNamed:@"images/level_home/levelImage_2.png"];
    
    // DONGcode - button 2 background to light grey
    [[self.button_stage2 layer] setBackgroundColor:[UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1].CGColor];
    
    // DONGcode - change button 1 background to dark grey
    [[self.button_stage1 layer] setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1].CGColor];
    
    // DONGcode - change button 3 background to dark grey
    [[self.button_stage3 layer] setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1].CGColor];
    
    
    /*
     // highlight button 2 border
     [[self.button_stage2 layer] setBorderWidth:1.0f];
     [[self.button_stage2 layer] setBorderColor:[UIColor whiteColor].CGColor];
     // unhighlight button 3 border
     self.button_stage3.layer.borderWidth = 1.0f;
     // unhighlight button 1 border
     self.button_stage1.layer.borderWidth = 1.0f;
     */
  }
  else // default button 1
  {
    // set start button title
    [self.button_start setTitle:@"Level I Start" forState:UIControlStateNormal];
    // set desc image
    self.image_levelDescription.image = [UIImage imageNamed:@"images/level_home/levelImage_1.png"];
    
    
    // DONGcode - change button 1 background to light grey
    [[self.button_stage1 layer] setBackgroundColor:[UIColor colorWithRed:77.0/255.0 green:77.0/255.0 blue:77.0/255.0 alpha:1].CGColor];
    
    // DONGcode - change button 2 background to dark grey
    [[self.button_stage2 layer] setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1].CGColor];
    
    // DONGcode - change button 3 background to dark grey
    [[self.button_stage3 layer] setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1].CGColor];
    
    /*
     // highlight button 1 border
     [[self.button_stage1 layer] setBorderWidth:1.0f];
     [[self.button_stage1 layer] setBorderColor:[UIColor whiteColor].CGColor];
     // unhighlight button 2 border + color
     self.button_stage2.layer.borderWidth = 1.0f;
     // unhighlight button 3 border + color
     self.button_stage3.layer.borderWidth = 1.0f;
     */
  }
}

- (void) stageActivate: (int) stage
{
  NSLog(@"NANANNAN %@", self.lvl_home_inputUserName);
  
  if (self.lvl_home_inputUserName == (id)[NSNull null]
      || self.lvl_home_inputUserName.length == 0
      || [self.lvl_home_inputUserName isEqualToString:DEFAULT_PLAYER_NAME_STR])
  {
    // incorrect username
    return;
  }
  
  if (stage == 2)
  {
    // Get level total puzzles
    [PFCloud callFunctionInBackground:@"getPlayerStageTwoTotalPuzzles" withParameters:@{@"playerName":self.lvl_home_inputUserName} block:^(id object, NSError *error){
      if (!error){
        NSLog(@"Stage2 Total Puzzles %@", object);
        self.label_levelTotalPuzzles.text = [NSString stringWithFormat:@"%@", object];
      }
    }];
    
    // Get level total correct puzzles
    [PFCloud callFunctionInBackground:@"getPlayerStageTwoTotalCorrectPuzzles" withParameters:@{@"playerName":self.lvl_home_inputUserName} block:^(id object, NSError *error){
      if (!error){
        NSLog(@"Stage2 Total Correct Puzzles %@", object);
        self.label_levelTotalCorrectPuzzles.text = [NSString stringWithFormat:@"%@", object];
      }
    }];
    
    // Get level response time
    [PFCloud callFunctionInBackground:@"getPlayerStageTwoResponseTime" withParameters:@{@"playerName":self.lvl_home_inputUserName} block:^(id object, NSError *error){
      if (!error){
        NSLog(@"Stage2 Response Time %@", object);
        self.label_levelAverageResponseTime.text = [NSString stringWithFormat:@"%@", object];
      }
    }];
  }
  else if (stage == 3)
  {
    // Get level total puzzles
    [PFCloud callFunctionInBackground:@"getPlayerStageThreeTotalPuzzles" withParameters:@{@"playerName":self.lvl_home_inputUserName} block:^(id object, NSError *error){
      if (!error){
        NSLog(@"Stage3 Total Puzzles %@", object);
        self.label_levelTotalPuzzles.text = [NSString stringWithFormat:@"%@", object];
      }
    }];
    
    // Get level total correct puzzles
    [PFCloud callFunctionInBackground:@"getPlayerStageThreeTotalCorrectPuzzles" withParameters:@{@"playerName":self.lvl_home_inputUserName} block:^(id object, NSError *error){
      if (!error){
        NSLog(@"Stage3 Total Correct %@", object);
        self.label_levelTotalCorrectPuzzles.text = [NSString stringWithFormat:@"%@", object];
      }
    }];
    
    // Get level response time
    [PFCloud callFunctionInBackground:@"getPlayerStageThreeResponseTime" withParameters:@{@"playerName":self.lvl_home_inputUserName} block:^(id object, NSError *error){
      if (!error){
        NSLog(@"Stage3 Response Time %@", object);
        self.label_levelAverageResponseTime.text = [NSString stringWithFormat:@"%@", object];
      }
    }];
  }
  else if (stage == 1)// default level 1
  {
    // Get level total puzzles
    [PFCloud callFunctionInBackground:@"getPlayerStageOneTotalPuzzles" withParameters:@{@"playerName":self.lvl_home_inputUserName} block:^(id object, NSError *error){
      if (!error){
        NSLog(@"Stage1 Total Puzzles %@", object);
        self.label_levelTotalPuzzles.text = [NSString stringWithFormat:@"%@", object];
      }
    }];
    
    // Get level total correct puzzles
    [PFCloud callFunctionInBackground:@"getPlayerStageOneTotalCorrectPuzzles" withParameters:@{@"playerName":self.lvl_home_inputUserName} block:^(id object, NSError *error){
      if (!error){
        NSLog(@"Stage1 Total Correct Puzzles %@", object);
        self.label_levelTotalCorrectPuzzles.text = [NSString stringWithFormat:@"%@", object];
      }
    }];

    // Get level response time
    [PFCloud callFunctionInBackground:@"getPlayerStageOneResponseTime" withParameters:@{@"playerName":self.lvl_home_inputUserName} block:^(id object, NSError *error){
      if (!error){
        NSLog(@"Stage1 Response Time %@", object);
        self.label_levelAverageResponseTime.text = [NSString stringWithFormat:@"%@", object];
      }
    }];
  }
}

//-(void) highStageButtonBorder
//{
//  [self.button_stage1 addTarget:self action:@selector(highStageButtonBorder) forControlEvents:UIControlEventTouchDown];
//  [self.button_stage1 addTarget:self action:@selector(highStageButtonBorder) forControlEvents:UIControlEventTouchUpInside];
//
//  [self.button_stage2 addTarget:self action:@selector(highStageButtonBorder) forControlEvents:UIControlEventTouchDown];
//  [self.button_stage2 addTarget:self action:@selector(highStageButtonBorder) forControlEvents:UIControlEventTouchUpInside];
//
//  [self.button_stage3 addTarget:self action:@selector(highStageButtonBorder) forControlEvents:UIControlEventTouchDown];
//  [self.button_stage3 addTarget:self action:@selector(highStageButtonBorder) forControlEvents:UIControlEventTouchUpInside];
//
//
//  int value = 0;
//
//  if (value == 3)
//  {
//    self.button_stage1.layer.borderColor = [[UIColor blackColor]CGColor];
//    self.button_stage2.layer.borderColor = [[UIColor blackColor]CGColor];
//    self.button_stage3.layer.borderColor = [[UIColor whiteColor]CGColor]; // change color
//  }
//  else if (value == 2)
//  {
//    self.button_stage1.layer.borderColor = [[UIColor blackColor]CGColor];
//    self.button_stage2.layer.borderColor = [[UIColor whiteColor]CGColor];
//    self.button_stage3.layer.borderColor = [[UIColor blackColor]CGColor]; // change color
//  }
//  else
//  {
//    self.button_stage1.layer.borderColor = [[UIColor whiteColor]CGColor];
//    self.button_stage2.layer.borderColor = [[UIColor whiteColor]CGColor];
//    self.button_stage3.layer.borderColor = [[UIColor whiteColor]CGColor]; // change color
//  }
//}

@end
