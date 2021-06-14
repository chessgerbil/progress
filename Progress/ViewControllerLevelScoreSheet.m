//
//  ViewControllerLevelScoreSheet.m
//  Progress
//
//  Created by Sudhir Sawarkar on 11/7/15.
//  Copyright © 2015 Catamaran Labs. All rights reserved.
//

#import "ViewControllerLevelScoreSheet.h"
#import "DataStoreConfiguration.h"
#import "ViewControllerLevelHome.h"
#import "ViewControllerLevelOneOne.h"
#import "ViewControllerLevelOneTwo.h"
#import "ViewControllerLevelOneThree.h"
#import "ViewControllerLevelTwoOne.h"
#import "ViewControllerLevelTwoTwo.h"
#import "ViewControllerLevelThreeOne.h"
#import "ViewControllerLevelThreeTwo.h"
#import "ViewControllerLevelProgressChart.h"
#import <Parse/Parse.h>

@interface ViewControllerLevelScoreSheet ()
@property (weak, nonatomic) IBOutlet UIImageView *image_profilePic;
@property (weak, nonatomic) IBOutlet UIImageView *image_trophyCase; // removed from screen due to space constraints
@property (weak, nonatomic) IBOutlet UIImageView *image_progressChart;
@property (weak, nonatomic) IBOutlet UILabel *label_playerName;
@property (weak, nonatomic) IBOutlet UILabel *label_rank;
@property (weak, nonatomic) IBOutlet UILabel *label_fastAnswerCount;
@property (weak, nonatomic) IBOutlet UILabel *label_slowAnswerCount;
@property (weak, nonatomic) IBOutlet UILabel *label_okAnswerCount;
//@property (weak, nonatomic) IBOutlet UILabel *label_accuracy;
//@property (weak, nonatomic) IBOutlet UILabel *label_timeLeft;
@property (weak, nonatomic) IBOutlet UILabel *label_totalResponses;
@property (weak, nonatomic) IBOutlet UILabel *label_incorrectCount;
@property (weak, nonatomic) IBOutlet UIButton *button_nextLevel;
@property (weak, nonatomic) IBOutlet UILabel *label_back;

@property (weak, nonatomic) IBOutlet UILabel *label_correctResponses;
@property (weak, nonatomic) IBOutlet UILabel *label_avgResponseTime;
@property (weak, nonatomic) IBOutlet UILabel *label_accuracyResult;
@property (weak, nonatomic) IBOutlet UILabel *label_speedResult;

//DONGcode - added two new labels to explain TOP, AVERAGE, BELOW AVERGE
@property (weak, nonatomic) IBOutlet UILabel *label_AccuracyExp;
@property (weak, nonatomic) IBOutlet UILabel *label_SpeedExp;

@end

@implementation ViewControllerLevelScoreSheet

@synthesize lvl_scoreSheet_recvUserName,
            lvl_scoreSheet_levelNumberPlayed,
            lvl_scoreSheet_glbRank,
            lvl_scoreSheet_totalChoice,
            lvl_scoreSheet_totalCorrectAnswers,
            lvl_scoreSheet_fastAnswers,
            lvl_scoreSheet_slowAnswers,
            lvl_scoreSheet_okAnswers,
            lvl_scoreSheet_Accuracy,
            lvl_scoreSheet_incorrectAnswers,
            lvl_scoreSheet_averageResponseTime,
            lvl_scoreSheet_timeLeft;

- (void) addTapGestures
{
  UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackDetected)];
  backTap.numberOfTapsRequired = 1;
  [self.label_back setUserInteractionEnabled:YES];
  [self.label_back addGestureRecognizer:backTap];

  UITapGestureRecognizer *progressPicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProgressChartDetected)];
  progressPicTap.numberOfTapsRequired = 1;
  [self.image_progressChart setUserInteractionEnabled:YES];
  [self.image_progressChart addGestureRecognizer:progressPicTap];
}

-(void)tapProgressChartDetected
{
  ViewControllerLevelProgressChart *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelProgressChart"];
  [self presentViewController:vc animated:YES completion:nil];
}

-(void) tapBackDetected
{
  ViewControllerLevelHome *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelHome"];
  [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
  
  if (self.lvl_scoreSheet_totalCorrectAnswers <= 2)
  {
    [self.button_nextLevel setTitle:@"Play Again" forState:UIControlStateNormal];
  }
  else
  {
    [self.button_nextLevel setTitle:@"Next" forState:UIControlStateNormal];
  }
  
  NSLog(@"Passed Value %@", self.lvl_scoreSheet_recvUserName);
  
  [self loadScoreSheetImages];
  [self loadScoreSheetResults];
  [self uploadLevelResultsToParseBackEnd];
  [self addTapGestures];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void) loadScoreSheetImages
{
  self.image_profilePic.image = [UIImage imageNamed:@"images/level_score_sheet/profilePic.png"];
  self.image_trophyCase.image = [UIImage imageNamed:@"images/level_score_sheet/trophyCase.png"];
  self.image_progressChart.image = [UIImage imageNamed:@"images/level_score_sheet/progressChart.png"];

//  UIImage *seeResearch = [UIImage imageNamed:@"images/level_score_sheet/mainButton.png"];
//  [self.button_nextLevel setBackgroundImage:seeResearch forState:UIControlStateNormal];
  
//  if ((self.lvl_scoreSheet_recvUserName == (id)[NSNull null] || self.lvl_scoreSheet_recvUserName.length == 0 ))
//  {
//    self.lvl_scoreSheet_recvUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedPlayerName"];
//  }
}

- (void) loadScoreSheetResults
{
  //self.label_totalResponses.text   = [NSString stringWithFormat:@"%d", self.lvl_scoreSheet_totalChoice];
  //self.label_rank.text             = [NSString stringWithFormat:@"%d", self.lvl_scoreSheet_glbRank];
  //self.label_fastAnswerCount.text  = [NSString stringWithFormat:@"%d", self.lvl_scoreSheet_fastAnswers];
  //self.label_slowAnswerCount.text  = [NSString stringWithFormat:@"%d", self.lvl_scoreSheet_slowAnswers];
  //self.label_okAnswerCount.text    = [NSString stringWithFormat:@"%d", self.lvl_scoreSheet_okAnswers];
  //self.label_incorrectCount.text   = [NSString stringWithFormat:@"%d", self.lvl_scoreSheet_incorrectAnswers];
  //self.label_accuracy.text       = [NSString stringWithFormat:@"%d", self.lvl_scoreSheet_Accuracy];
  //self.label_timeLeft.text       = [NSString stringWithFormat:@"%d", self.lvl_scoreSheet_timeLeft];
  //self..text  = [NSString stringWithFormat:@"%d", self.lvl_scoreSheet_totalCorrectAnswers];
  //self..text  = [NSString stringWithFormat:@"%d", self.lvl_scoreSheet_levelNumberPlayed];

  [self.label_playerName setText:self.lvl_scoreSheet_recvUserName];

  // Calculate correct responses
  int totalCorrectResp = (self.lvl_scoreSheet_totalChoice - self.lvl_scoreSheet_incorrectAnswers);
  
  //DONG-code Display num of correct responses, avg response time IFF player plays at least 1 puzzle
  if (totalCorrectResp + self.lvl_scoreSheet_incorrectAnswers> 0)
  {
    self.label_correctResponses.text = [NSString stringWithFormat:@"%d", totalCorrectResp];
    self.label_avgResponseTime.text = [NSString stringWithFormat:@"%01d milliseconds", self.lvl_scoreSheet_averageResponseTime];
  }
  
  // Show Accuracy Result
  [self calculateAccuracyResult];
  
  // Show Speed Result
  [self calculateSpeedResult];
}

#define RESULT_ABOVE   @"TOP PERFORMER"
#define RESULT_AVERAGE @"AVERAGE"
#define RESULT_BELOW   @"BELOW AVERAGE"

- (void) calculateAccuracyResult
{
  int value = (self.lvl_scoreSheet_fastAnswers * 1) + (self.lvl_scoreSheet_okAnswers * 0) + (self.lvl_scoreSheet_slowAnswers * -1);

  if (self.lvl_scoreSheet_totalChoice < 1 )
  {
    self.label_accuracyResult.text = @"-";
    self.label_AccuracyExp.text = @"No responses - please play again";
  }
  else if (value > 7)
  {
    self.label_accuracyResult.text = RESULT_ABOVE;
    self.label_AccuracyExp.text = @"Top quartile in correct responses";
  }
  else if (value > 4 && value <= 7)
  {
    self.label_accuracyResult.text = RESULT_AVERAGE;
    self.label_AccuracyExp.text = @"Average number of correct responses";

  }
  else
  {
    self.label_accuracyResult.text = RESULT_BELOW;
    self.label_AccuracyExp.text = @"Bottom quartile in correct responses";

  }
}

- (void) calculateSpeedResult
{
  //int totalCorrectResp = (self.lvl_scoreSheet_totalChoice - self.lvl_scoreSheet_incorrectAnswers);
  //float avgTime = abs(DEFAULT_CURR_MILLISECOND_LEFT_MS - self.lvl_scoreSheet_timeLeft);
  int avg = round(self.lvl_scoreSheet_averageResponseTime);

  if (self.lvl_scoreSheet_totalChoice < 1)
  {
    self.label_speedResult.text = @"-";
    self.label_SpeedExp.text = @"No responses - please play again";
  }
  else if (avg < 500)
  {
    self.label_speedResult.text = RESULT_ABOVE;
    self.label_SpeedExp.text = @"Top quartile in response times";

  }
  else if (avg >= 500 && avg <= 700)
  {
    self.label_speedResult.text = RESULT_AVERAGE;
    self.label_SpeedExp.text = @"Average response times";

  }
  else
  {
    self.label_speedResult.text = RESULT_BELOW;
    self.label_SpeedExp.text = @"Slower than average response times";

  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAction_nextLevel:(id)sender
{
  if (self.lvl_scoreSheet_totalChoice <= 9)
  {
    // prevent from advancing to the next level
    // load the same level when the next button is pressed
    if (self.lvl_scoreSheet_levelNumberPlayed == LVL_PLAYED__ONE_ONE)
    {
      [self performSegueWithIdentifier:@"segue_levelScoreSheetToLevelOneOne" sender:sender];
      ViewControllerLevelOneOne *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelOneOne"];
      [self presentViewController:vc animated:YES completion:nil];
    }
    else if (self.lvl_scoreSheet_levelNumberPlayed == LVL_PLAYED__ONE_TWO)
    {
      [self performSegueWithIdentifier:@"segue_levelScoreSheetToLevelOneTwo" sender:sender];
      ViewControllerLevelOneTwo *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelOneTwo"];
      [self presentViewController:vc animated:YES completion:nil];
    }
    else if (self.lvl_scoreSheet_levelNumberPlayed == LVL_PLAYED__ONE_THREE)
    {
      [self performSegueWithIdentifier:@"segue_levelScoreSheetToLevelOneThree" sender:sender];
      ViewControllerLevelOneThree *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelOneThree"];
      [self presentViewController:vc animated:YES completion:nil];
    }
    else if (self.lvl_scoreSheet_levelNumberPlayed == LVL_PLAYED__TWO_ONE)
    {
     [self performSegueWithIdentifier:@"segue_levelScoreSheetToLevelTwoOne" sender:sender];
      ViewControllerLevelTwoOne *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelTwoOne"];
      [self presentViewController:vc animated:YES completion:nil];
    }
    else if (self.lvl_scoreSheet_levelNumberPlayed == LVL_PLAYED__TWO_TWO)
    {
     [self performSegueWithIdentifier:@"segue_levelScoreSheetToLevelTwoTwo" sender:sender];
      ViewControllerLevelTwoTwo *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelTwoTwo"];
      [self presentViewController:vc animated:YES completion:nil];
    }
    else if (self.lvl_scoreSheet_levelNumberPlayed == LVL_PLAYED__THREE_ONE)
    {
      [self performSegueWithIdentifier:@"segue_levelScoreSheetToLevelThreeOne" sender:sender];
      ViewControllerLevelThreeOne *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelThreeOne"];
      [self presentViewController:vc animated:YES completion:nil];
    }
    else if (self.lvl_scoreSheet_levelNumberPlayed == LVL_PLAYED__THREE_TWO)
    {
      [self performSegueWithIdentifier:@"segue_levelScoreSheetToLevelThreeTwo" sender:sender];
      ViewControllerLevelThreeTwo *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelThreeTwo"];
      [self presentViewController:vc animated:YES completion:nil];
    }
  
    [self.button_nextLevel setTitle:@"Play Again" forState:UIControlStateNormal];
    return; // prevent from advancing
  }
  
  // Advance based on the current level played
  if (self.lvl_scoreSheet_levelNumberPlayed == LVL_PLAYED__ONE_ONE)
  {
    [self performSegueWithIdentifier:@"segue_levelScoreSheetToLevelOneTwo" sender:sender];
    ViewControllerLevelOneTwo *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelOneTwo"];
    [self presentViewController:vc animated:YES completion:nil];
  }
  else if (self.lvl_scoreSheet_levelNumberPlayed == LVL_PLAYED__ONE_TWO)
  {
    [self performSegueWithIdentifier:@"segue_levelScoreSheetToLevelOneThree" sender:sender];
    ViewControllerLevelOneThree *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelOneThree"];
    [self presentViewController:vc animated:YES completion:nil];
  }
  else if (self.lvl_scoreSheet_levelNumberPlayed == LVL_PLAYED__ONE_THREE)
  {
    [self performSegueWithIdentifier:@"segue_levelScoreSheetToLevelTwoOne" sender:sender];
    ViewControllerLevelTwoOne *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelTwoOne"];
    [self presentViewController:vc animated:YES completion:nil];
  }
  else if (self.lvl_scoreSheet_levelNumberPlayed == LVL_PLAYED__TWO_ONE)
  {
    [self performSegueWithIdentifier:@"segue_levelScoreSheetToLevelTwoTwo" sender:sender];
    ViewControllerLevelTwoTwo *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelTwoTwo"];
    [self presentViewController:vc animated:YES completion:nil];
  }
  else if (self.lvl_scoreSheet_levelNumberPlayed == LVL_PLAYED__TWO_TWO)
  {
    [self performSegueWithIdentifier:@"segue_levelScoreSheetToLevelThreeOne" sender:sender];
    ViewControllerLevelThreeOne *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelThreeOne"];
    [self presentViewController:vc animated:YES completion:nil];
  }
  else if (self.lvl_scoreSheet_levelNumberPlayed == LVL_PLAYED__THREE_ONE)
  {
    [self performSegueWithIdentifier:@"segue_levelScoreSheetToLevelThreeTwo" sender:sender];
    ViewControllerLevelThreeTwo *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelThreeTwo"];
    [self presentViewController:vc animated:YES completion:nil];
  }
  else
  {
    // next level
  }
  
  [self.button_nextLevel setTitle:@"Next" forState:UIControlStateNormal];
}

- (IBAction)buttonAction_backHome:(id)sender
{
  ViewControllerLevelHome *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelHome"];
  [self presentViewController:vc animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) uploadLevelResultsToParseBackEnd
{
  // check player name for NULL
  if (   self.lvl_scoreSheet_recvUserName == (id)[NSNull null]
      || self.lvl_scoreSheet_recvUserName.length == 0
      || self.lvl_scoreSheet_totalChoice == 0   )
  {
    return;
  }

  NSString *deviceName = DEFAULT_EMPTY__STR;
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    deviceName = @"iPad";
  }
  else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    deviceName = @"iPhone";
  }
  else
  {
    deviceName = @"Unknown";
  }
  
  // Save information information in Parse
  PFObject * playerInfo = [PFObject objectWithClassName:@"stageAssemble"];
  [playerInfo setObject:self.lvl_scoreSheet_recvUserName                                 forKey:@"playerName"];
  [playerInfo setObject:deviceName                                                       forKey:@"playerDevice"];
  [playerInfo setObject:[NSNumber numberWithInt:self.lvl_scoreSheet_totalChoice]         forKey:@"totalResponses"];
  [playerInfo setObject:[NSNumber numberWithInt:self.lvl_scoreSheet_fastAnswers]         forKey:@"totalResponsesFast"];
  [playerInfo setObject:[NSNumber numberWithInt:self.lvl_scoreSheet_slowAnswers]         forKey:@"totalResponsesSlow"];
  [playerInfo setObject:[NSNumber numberWithInt:self.lvl_scoreSheet_okAnswers]           forKey:@"totalResponsesOk"];
  [playerInfo setObject:[NSNumber numberWithInt:self.lvl_scoreSheet_incorrectAnswers]    forKey:@"totalResponsesWrong"];
  [playerInfo setObject:[NSNumber numberWithInt:self.lvl_scoreSheet_levelNumberPlayed]   forKey:@"levelPlayed"];
  [playerInfo setObject:[NSNumber numberWithInt:self.lvl_scoreSheet_timeLeft]            forKey:@"levelTimeLeftInMs"];
  [playerInfo setObject:[NSNumber numberWithInt:self.lvl_scoreSheet_averageResponseTime] forKey:@"levelAverageResponseTimeInMs"];

  [playerInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
  {
   if (succeeded)
   {
     NSLog(@"object uploaded for level");
   }
   else
   {
     NSString *errorString = [[error userInfo] objectForKey:@"error"];
     NSLog(@"Error from level one object upload:%@", errorString);
   }
  }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  NSLog(@"Player Name passed from score sheet: %@", self.lvl_scoreSheet_recvUserName);
  
  if ([segue.identifier isEqualToString:@"segue_levelScoreSheetToLevelOneOne"])
  {
    ViewControllerLevelOneOne *vc = (ViewControllerLevelOneOne *)segue.destinationViewController;
    vc.lvl_recvUserName = self.lvl_scoreSheet_recvUserName ;
  }
  else if ([segue.identifier isEqualToString:@"segue_levelScoreSheetToLevelOneTwo"])
  {
    ViewControllerLevelOneTwo *vc = (ViewControllerLevelOneTwo *)segue.destinationViewController;
    vc.lvl_recvUserName = self.lvl_scoreSheet_recvUserName ;
  }
  else if ([segue.identifier isEqualToString:@"segue_levelScoreSheetToLevelOneThree"])
  {
    ViewControllerLevelOneThree *vc = (ViewControllerLevelOneThree *)segue.destinationViewController;
    vc.lvl_recvUserName = self.lvl_scoreSheet_recvUserName ;
  }
  else if ([segue.identifier isEqualToString:@"segue_levelScoreSheetToLevelTwoOne"])
  {
    ViewControllerLevelTwoOne *vc = (ViewControllerLevelTwoOne *)segue.destinationViewController;
    vc.lvl_recvUserName = self.lvl_scoreSheet_recvUserName ;
  }
  else if ([segue.identifier isEqualToString:@"segue_levelScoreSheetToLevelTwoTwo"])
  {
    ViewControllerLevelTwoTwo *vc = (ViewControllerLevelTwoTwo *)segue.destinationViewController;
    vc.lvl_recvUserName = self.lvl_scoreSheet_recvUserName ;
  }
  else if ([segue.identifier isEqualToString:@"segue_levelScoreSheetToLevelThreeOne"])
  {
    ViewControllerLevelThreeOne *vc = (ViewControllerLevelThreeOne *)segue.destinationViewController;
    vc.lvl_recvUserName = self.lvl_scoreSheet_recvUserName ;
  }
  else if ([segue.identifier isEqualToString:@"segue_levelScoreSheetToLevelThreeTwo"])
  {
    ViewControllerLevelThreeTwo *vc = (ViewControllerLevelThreeTwo *)segue.destinationViewController;
    vc.lvl_recvUserName = self.lvl_scoreSheet_recvUserName ;
  }
}

@end
