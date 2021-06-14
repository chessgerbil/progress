//
//  ViewControllerLevelOneThree.m
//  Progress
//
//  Created by Sudhir Sawarkar on 11/7/15.
//  Copyright © 2015 Catamaran Labs. All rights reserved.
//

#import "ViewControllerLevelOneThree.h"
#import "ViewControllerLevelHome.h"
#import "DataStoreConfiguration.h"
#import "ViewControllerLevelScoreSheet.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewControllerLevelOneThree ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView_referent;
@property (weak, nonatomic) IBOutlet UIButton *button_choiceBotLeft;
@property (weak, nonatomic) IBOutlet UIButton *button_choiceBotRight;
@property (weak, nonatomic) IBOutlet UIButton *button_choiceTopRight;
@property (weak, nonatomic) IBOutlet UIButton *button_choiceTopLeft;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView_correctCount;
@property (weak, nonatomic) IBOutlet UILabel *label_levelName;
@property (weak, nonatomic) IBOutlet UILabel *label_timeLeft;
@property (weak, nonatomic) IBOutlet UILabel *label_rewards;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_animagedProgressBar;
@property (weak, nonatomic) IBOutlet UILabel *label_back;

// User defined
@property (nonatomic) int   lvl1_3_totalCorrectChoiceCount;
@property (nonatomic) int   lvl1_3_totalCorrectFastCount;
@property (nonatomic) int   lvl1_3_totalCorrectSlowCount;
@property (nonatomic) int   lvl1_3_totalCorrectOkCount;
@property (nonatomic) int   lvl1_3_totalChoiceCount;
@property (nonatomic) BOOL  lvl_1_3_countDownTimerRunningStatusFlag;
@property (nonatomic) float lvl1_3_progressViewCorrectCountValue;

@property (nonatomic) int lvl1_3_currMinute;
@property (nonatomic) int lvl1_3_currSeconds;
@property (nonatomic) int lvl1_3_currMilliseconds;
@property (nonatomic) int lvl1_3_prevMilliSeconds;
@property (nonatomic) int lvl1_3_responseMilliSeconds;
@property (strong, nonatomic) NSTimer *lvl1_3_countDownTimer;
@property (strong, nonatomic) NSDate  *lvl1_3_startDate;

@property (nonatomic, retain) NSArray *lvl1_3_referentTypeArr;
@property (nonatomic, retain) NSArray *lvl1_3_referentSubTypeArr;
@property (nonatomic, retain) NSArray *lvl1_3_referentColorArr;
@property (nonatomic, retain) NSArray *lvl1_3_progressBarImageArr;

@property (nonatomic) NSString *lvl1_3_referentImagePathAsString;
@property (nonatomic) NSString *lvl1_3_choiceBotLeftImagePathAsString;
@property (nonatomic) NSString *lvl1_3_choiceBotRightImagePathAsString;
@property (nonatomic) NSString *lvl1_3_choiceTopLeftImagePathAsString;
@property (nonatomic) NSString *lvl1_3_choiceTopRightImagePathAsString;

@end

@implementation ViewControllerLevelOneThree

@synthesize lvl1_3_totalCorrectChoiceCount,
lvl1_3_totalCorrectFastCount,
lvl1_3_totalCorrectSlowCount,
lvl1_3_totalCorrectOkCount,
lvl1_3_totalChoiceCount,
lvl_1_3_countDownTimerRunningStatusFlag,
lvl1_3_progressViewCorrectCountValue;

@synthesize lvl1_3_currMinute,
lvl1_3_currSeconds,
lvl1_3_currMilliseconds,
lvl1_3_prevMilliSeconds,
lvl1_3_responseMilliSeconds,
lvl1_3_countDownTimer,
lvl1_3_startDate;

@synthesize lvl1_3_referentTypeArr,
lvl1_3_referentSubTypeArr,
lvl1_3_progressBarImageArr,
lvl1_3_referentColorArr;

@synthesize lvl1_3_referentImagePathAsString,
lvl1_3_choiceBotLeftImagePathAsString,
lvl1_3_choiceBotRightImagePathAsString,
lvl1_3_choiceTopLeftImagePathAsString,
lvl1_3_choiceTopRightImagePathAsString;

@synthesize lvl_recvUserName;

- (void) viewDidAppear:(BOOL)animated
{
  [self initImageArrays];
  [self initLvlVariables];
  
  //  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Level 1.1" message:@"Tap to match from 2 choices" preferredStyle:UIAlertControllerStyleAlert];
  //  [self presentViewController:alertController animated:YES completion:nil];
  //
  //  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
  //    [self startCountDownTimer];
  //    [alertController dismissViewControllerAnimated:YES completion:^{
  //      // do something ?
  //    }];
  //  });
  
  [self componentsActivate:YES];
  UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
  imgView.image = [UIImage imageNamed:@"images/game_screen/TAP_launch.png"];
  [self.view addSubview:imgView];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    imgView.image = nil;
    [self addTapGestures];
    [self componentsActivate:NO];
    [self initCompnentsDefaults];
    [self updateViewWithRandomImages];
    [self startCountDownTimer];
  });
}

- (void) componentsActivate:(BOOL)status
{
  self.label_levelName.hidden               = status;
  self.label_timeLeft.hidden                = status;
  self.label_rewards.hidden                 = status;
  self.label_back.hidden                    = status;
  self.button_choiceBotRight.hidden         = status;
  self.button_choiceBotLeft.hidden          = status;
  self.button_choiceTopRight.hidden         = status;
  self.button_choiceTopLeft.hidden          = status;
  self.imageView_referent.hidden            = status;
  self.imageView_animagedProgressBar.hidden = status;
}

- (void) addTapGestures
{
  UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackDetected)];
  backTap.numberOfTapsRequired = 1;
  [self.label_back setUserInteractionEnabled:YES];
  [self.label_back addGestureRecognizer:backTap];
  
  UITapGestureRecognizer *levelNameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLevelNameDetected)];
  levelNameTap.numberOfTapsRequired = 1;
  [self.label_levelName setUserInteractionEnabled:YES];
  [self.label_levelName addGestureRecognizer:levelNameTap];
}

-(void) tapBackDetected
{
  [self invalidateLvl];
  ViewControllerLevelHome *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelHome"];
  [self presentViewController:vc animated:YES completion:nil];
}

-(void) tapLevelNameDetected
{
  
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  //[self initImageArrays];
  //[self initLvlVariables];
  [self initCompnentsDefaultsAtLoadUp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initImageArrays
{
  self.lvl1_3_referentTypeArr = [[NSArray alloc] initWithObjects:@"images/level_one/type_0",
                                 @"images/level_one/type_1",
                                 @"images/level_one/type_2",
                                 @"images/level_one/type_3",
                                 nil];
  
  self.lvl1_3_referentSubTypeArr = [[NSArray alloc] initWithObjects:@"/sub_type_0",
                                    @"/sub_type_1",
                                    @"/sub_type_2",
                                    @"/sub_type_3",
                                    @"/sub_type_4",
                                    @"/sub_type_5",
                                    @"/sub_type_6",
                                    @"/sub_type_7",
                                    nil];
  
  self.lvl1_3_referentColorArr = [[NSArray alloc] initWithObjects:@"/Blue.png",
                                  @"/Gray.png",
                                  @"/Green.png",
                                  @"/Orange.png",
                                  @"/Purple.png",
                                  @"/Red.png",
                                  @"/Yellow.png",
                                  nil];
  
  
  self.lvl1_3_progressBarImageArr = [[NSArray alloc] initWithObjects:@"images/progress_bar/progress_bar_percent_0.png",
                                     @"images/progress_bar/progress_bar_percent_10.png",
                                     @"images/progress_bar/progress_bar_percent_20.png",
                                     @"images/progress_bar/progress_bar_percent_30.png",
                                     @"images/progress_bar/progress_bar_percent_40.png",
                                     @"images/progress_bar/progress_bar_percent_50.png",
                                     @"images/progress_bar/progress_bar_percent_60.png",
                                     @"images/progress_bar/progress_bar_percent_70.png",
                                     @"images/progress_bar/progress_bar_percent_80.png",
                                     @"images/progress_bar/progress_bar_percent_90.png",
                                     @"images/progress_bar/progress_bar_percent_100.png",
                                     nil];
}

- (void) initCompnentsDefaultsAtLoadUp
{
  self.imageView_animagedProgressBar.image = nil;
  
  [self.button_choiceBotLeft  setTitle:DEFAULT_EMPTY__STR forState:UIControlStateNormal];
  [self.button_choiceBotRight setTitle:DEFAULT_EMPTY__STR forState:UIControlStateNormal];
  [self.button_choiceTopLeft  setTitle:DEFAULT_EMPTY__STR forState:UIControlStateNormal];
  [self.button_choiceTopRight setTitle:DEFAULT_EMPTY__STR forState:UIControlStateNormal];
  self.label_levelName.text = DEFAULT_EMPTY__STR;
  self.label_timeLeft.text  = DEFAULT_EMPTY__STR;
  self.label_rewards.text   = DEFAULT_EMPTY__STR;
  self.label_back.text      = DEFAULT_EMPTY__STR;
}

- (void) initCompnentsDefaults
{
  self.imageView_animagedProgressBar.image = [UIImage imageNamed:[lvl1_3_progressBarImageArr objectAtIndex:0]]; // 0 percent index
  
  [self.button_choiceBotLeft  setTitle:DEFAULT_EMPTY__STR forState:UIControlStateNormal];
  [self.button_choiceBotRight setTitle:DEFAULT_EMPTY__STR forState:UIControlStateNormal];
  [self.button_choiceTopLeft  setTitle:DEFAULT_EMPTY__STR forState:UIControlStateNormal];
  [self.button_choiceTopRight setTitle:DEFAULT_EMPTY__STR forState:UIControlStateNormal];
  self.label_levelName.text = @"LEVEL 1.3";
  self.label_timeLeft.text  = DEFAULT_TIME_LEFT_STR;
  self.label_rewards.text   = DEFAULT_EMPTY__STR;
  self.label_back.text      = DEFAULT_BACK_BUTTON_STR;
}

- (void) initLvlVariables
{
  self.lvl_1_3_countDownTimerRunningStatusFlag = NO;
  
  self.lvl1_3_currSeconds      = 0;
  self.lvl1_3_currMinute       = 0;
  self.lvl1_3_prevMilliSeconds = 0;
  self.lvl1_3_responseMilliSeconds = 0;
  self.lvl1_3_currMilliseconds = DEFAULT_CURR_MILLISECOND_LEFT_MS; // count down timer in milliseconds
  
  self.lvl1_3_totalChoiceCount        = 0;
  self.lvl1_3_totalCorrectChoiceCount = 0;
  self.lvl1_3_totalCorrectFastCount   = 0;
  self.lvl1_3_totalCorrectSlowCount   = 0;
  self.lvl1_3_totalCorrectOkCount     = 0;
  
  self.progressView_correctCount.progress = 0;
}

- (void) invalidateLvl
{
  [self.button_choiceBotLeft setEnabled:NO];
  [self.button_choiceBotRight setEnabled:NO];
  [self.button_choiceTopLeft setEnabled:NO];
  [self.button_choiceTopRight setEnabled:NO];
  [self.lvl1_3_countDownTimer invalidate];
  self.lvl1_3_countDownTimer = nil;
  [self loadNextView];
}

- (void) updateCountDownTimer
{
  self.lvl1_3_currMilliseconds -= 10 ;
  
  int seconds = self.lvl1_3_currMilliseconds / 1000;
  int minutes = seconds / 60;
  int hours   = minutes / 60;
  
  seconds -= minutes * 60;
  minutes -= hours * 60;
  
  //  NSString * printTimer = [NSString stringWithFormat:@"%@%02d:%02d:%02d:%02d",
  //                                                     (self.lvl1_currMilliSeconds < 0 ? @"-" : @""),
  //                                                     hours,
  //                                                     minutes,
  //                                                     seconds,
  //                                                     self.lvl1_currMilliSeconds % 1000];
  //NSString * printTimer = [NSString stringWithFormat:@"%02d", seconds];
  NSString * printTimer = [NSString stringWithFormat:@"%02d", self.lvl1_3_currMilliseconds/100];
  self.label_timeLeft.text = printTimer;
  
  //DONGcode - play sound 'Time Low'
  static bool playFlag = FALSE;
  
  if (playFlag == FALSE && self.lvl1_3_currMilliseconds < 4000)
  {
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"audio/Time low" ofType:@"aiff"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
    playFlag = TRUE;
  }

  // change color of downtime below < 20
  if (self.lvl1_3_currMilliseconds < 2000)
  {
    self.label_timeLeft.textColor = [UIColor redColor];
  }
  
  if (self.lvl1_3_currMilliseconds < 0)
  {
    [self invalidateLvl];
  }
}

- (void) updateRewardScore: (int) answerType
{
  if (answerType)
  {
    // correct answer
    self.lvl1_3_totalCorrectChoiceCount++; // increment correct count
    //self.label_rewards.text = @"";
    [self calculateResponseTime:self.lvl1_3_currMilliseconds];
    
    //DONGcode - play sound 'Right Choice'
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"audio/Right 2" ofType:@"aiff"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
  }
  else
  {
    self.lvl1_3_currMilliseconds -= LVL_THREE__RESPONSE_WRONG_TIMER_SUBSTRACT_MS;
    self.label_rewards.text = @"WRONG";
    //self.label_lvl1_answerResponseAddTime.text = @"-1";
    
    //DONGcode - play sound 'Wrong Choice'
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"audio/Incorrect 1" ofType:@"aiff"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
  }
  
  [self updateRewardProgressBar];
}

- (void) calculateResponseTime: (int) currTime
{
  static int referTime = DEFAULT_CURR_MILLISECOND_LEFT_MS;
  
  if (self.lvl1_3_responseMilliSeconds == 0)
  {
    referTime = DEFAULT_CURR_MILLISECOND_LEFT_MS;
  }
  
  self.lvl1_3_responseMilliSeconds += abs(currTime - referTime);
  referTime = currTime;
}

- (void) upDateRewardTimer:(int) rewardMilliSeconds
{
  if (rewardMilliSeconds < LVL_THREE__RESPONSE_FAST_TIMER_ADD_MS)
  {
    self.lvl1_3_currMilliseconds += LVL_THREE__REWARD_FAST_TIMER_ADD_MS;
    self.label_rewards.text = @"FAST";
    self.lvl1_3_totalCorrectFastCount++;
    //self.label_lvl1_answerResponseAddTime.text = @"+0.7";
    
  }
  else if (rewardMilliSeconds < LVL_THREE__RESPONSE_NORMAL_TIMER_ADD_MS)
  {
    self.lvl1_3_currMilliseconds += LVL_THREE__REWARD_NORMAL_TIMER_ADD_MS;
    self.label_rewards.text = @"GOOD";
    self.lvl1_3_totalCorrectOkCount++;
    //self.label_lvl1_answerResponseAddTime.text = @"+1.2";
  }
  else
  {
    self.lvl1_3_currMilliseconds += LVL_THREE__REWARD_SLOW_TIMER_ADD_MS;
    self.label_rewards.text = @"SLOW";
    self.lvl1_3_totalCorrectSlowCount++;
    //self.label_lvl1_answerResponseAddTime.text = @"+1.8";
  }
}

- (void) updateRewardProgressBar
{
  if (self.lvl1_3_totalChoiceCount < LVL_ONE__PUZZLES_PER_LEVEL_MAX)
  {
    //float value = (float) self.lvl1_3_totalCorrectChoiceCount / LVL_THREE__PUZZLES_PER_LEVEL_MAX;
    //self.progressView_correctCount.progress = value;
    self.imageView_animagedProgressBar.image = [UIImage imageNamed:[lvl1_3_progressBarImageArr objectAtIndex:self.lvl1_3_totalCorrectChoiceCount]];
  }
}

- (IBAction)buttonAction_choiceTopRight:(id)sender {
  [self handleChoiceButtonAction:CHOICE_SELECTED__TOP_RIGHT];
}

- (IBAction)buttonAction_choiceTopLeft:(id)sender {
  [self handleChoiceButtonAction:CHOICE_SELECTED__TOP_LEFT];
}

- (IBAction)buttonAction_choiceBotLeft:(id)sender {
  [self handleChoiceButtonAction:CHOICE_SELECTED__BOTTOM_LEFT];
}

- (IBAction)buttonAction_choiceBotRight:(id)sender {
  [self handleChoiceButtonAction:CHOICE_SELECTED__BOTTOM_RIGHT];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) startCountDownTimer
{
  // if timer is not running; restart the timer here
  if (self.lvl_1_3_countDownTimerRunningStatusFlag == NO)
  {
    self.lvl_1_3_countDownTimerRunningStatusFlag = YES;
    self.lvl1_3_startDate = [NSDate date];
    self.lvl1_3_countDownTimer = [NSTimer scheduledTimerWithTimeInterval: .01
                                                                  target: self
                                                                selector: @selector(updateCountDownTimer)
                                                                userInfo: nil
                                                                 repeats: YES];
    self.lvl1_3_prevMilliSeconds = self.lvl1_3_currMilliseconds;
  }
}

- (void) handleChoiceButtonAction: (int) val
{
  int rewardMilliSeconds          = 0;
  
  // if total referent image counter has exceeded the limit for current game
  if (self.lvl1_3_totalChoiceCount >= LVL_THREE__PUZZLES_PER_LEVEL_MAX)
  {
    [self invalidateLvl];
    return;
  }
  else
  {
    self.lvl1_3_totalChoiceCount++;
  }
  
  // based on the button pressed if correct reward time
  rewardMilliSeconds = self.lvl1_3_prevMilliSeconds - self.lvl1_3_currMilliseconds; //self.lvl1_currMilliSeconds(not count down timer hence diff sub)
  self.lvl1_3_prevMilliSeconds = self.lvl1_3_currMilliseconds;
  [self upDateRewardTimer:rewardMilliSeconds];
  
  // check which button is pressed
  if (val == CHOICE_SELECTED__BOTTOM_LEFT)
  {
    if([self.lvl1_3_referentImagePathAsString isEqualToString:self.lvl1_3_choiceBotLeftImagePathAsString])
    {
      // correct answer
      [self updateRewardScore:YES];
    }
    else
    {
      [self updateRewardScore:NO];
    }
  }
  else if (val == CHOICE_SELECTED__BOTTOM_RIGHT)
  {
    if([self.lvl1_3_referentImagePathAsString isEqualToString:self.lvl1_3_choiceBotRightImagePathAsString])
    {
      // correct answer
      [self updateRewardScore:YES];
    }
    else
    {
      [self updateRewardScore:NO];
    }
  }
  else if (val == CHOICE_SELECTED__TOP_LEFT)
  {
    if([self.lvl1_3_referentImagePathAsString isEqualToString:self.lvl1_3_choiceTopLeftImagePathAsString])
    {
      // correct answer
      [self updateRewardScore:YES];
    }
    else
    {
      [self updateRewardScore:NO];
    }
  }
  else if (val == CHOICE_SELECTED__TOP_RIGHT)
  {
    if([self.lvl1_3_referentImagePathAsString isEqualToString:self.lvl1_3_choiceTopRightImagePathAsString])
    {
      // correct answer
      [self updateRewardScore:YES];
    }
    else
    {
      [self updateRewardScore:NO];
    }
  }

  
  [self updateViewWithRandomImages];
}

- (void) updateViewWithRandomImages
{
  // select button on randomness
  int temp = arc4random() % LVL_THREE__CHOICE_BUTTON_TOTAL_COUNT;
  
  self.lvl1_3_referentImagePathAsString = [self getRandomReferentImagePathAsString];
  
  if (temp == 0)
  {
    self.lvl1_3_choiceBotRightImagePathAsString  = self.lvl1_3_referentImagePathAsString;
    self.lvl1_3_choiceBotLeftImagePathAsString   = [self getRandomReferentImagePathAsString];
    self.lvl1_3_choiceTopRightImagePathAsString  = [self getRandomReferentImagePathAsString];
    self.lvl1_3_choiceTopLeftImagePathAsString   = [self getRandomReferentImagePathAsString];
  }
  else if (temp == 1)
  {
    self.lvl1_3_choiceBotRightImagePathAsString  = [self getRandomReferentImagePathAsString];
    self.lvl1_3_choiceBotLeftImagePathAsString   = self.lvl1_3_referentImagePathAsString;
    self.lvl1_3_choiceTopRightImagePathAsString  = [self getRandomReferentImagePathAsString];
    self.lvl1_3_choiceTopLeftImagePathAsString   = [self getRandomReferentImagePathAsString];
  }
  else if (temp == 2)
  {
    self.lvl1_3_choiceBotRightImagePathAsString  = [self getRandomReferentImagePathAsString];
    self.lvl1_3_choiceBotLeftImagePathAsString   = [self getRandomReferentImagePathAsString];
    self.lvl1_3_choiceTopRightImagePathAsString  = self.lvl1_3_referentImagePathAsString;
    self.lvl1_3_choiceTopLeftImagePathAsString   = [self getRandomReferentImagePathAsString];
  }
  else if (temp == 3)
  {
    self.lvl1_3_choiceBotRightImagePathAsString  = [self getRandomReferentImagePathAsString];
    self.lvl1_3_choiceBotLeftImagePathAsString   = [self getRandomReferentImagePathAsString];
    self.lvl1_3_choiceTopRightImagePathAsString  = [self getRandomReferentImagePathAsString];
    self.lvl1_3_choiceTopLeftImagePathAsString   = self.lvl1_3_referentImagePathAsString;
  }

  
  //NSLog(@"String %@", [self getReferentImagePathAsString]);
  // set referent image and choices
  self.imageView_referent.image = [UIImage imageNamed:self.lvl1_3_referentImagePathAsString];
  // set bot left choice image
  UIImage *left = [UIImage imageNamed:self.lvl1_3_choiceBotLeftImagePathAsString];
  [self.button_choiceBotLeft setBackgroundImage:left forState:UIControlStateNormal];
  // set bot right choice image
  UIImage *right = [UIImage imageNamed:self.lvl1_3_choiceBotRightImagePathAsString];
  [self.button_choiceBotRight setBackgroundImage:right forState:UIControlStateNormal];
  // set top left choice image
  UIImage *tleft = [UIImage imageNamed:self.lvl1_3_choiceTopLeftImagePathAsString];
  [self.button_choiceTopLeft setBackgroundImage:tleft forState:UIControlStateNormal];
  // set top right choice image
  UIImage *tright = [UIImage imageNamed:self.lvl1_3_choiceTopRightImagePathAsString];
  [self.button_choiceTopRight setBackgroundImage:tright forState:UIControlStateNormal];
}

- (int) getRandomNumber: (int) maxValue
{
  return (arc4random() % maxValue);
}

- (NSString *) getRandomReferentTypeArrayString
{
  
  return (self.lvl1_3_referentTypeArr[[self getRandomNumber:LVL_IMAGES_CATEGORY__TYPE_COUNT]]);
}

- (NSString *) getRandomReferentSubTypeArrayString
{
  
  return (self.lvl1_3_referentSubTypeArr[[self getRandomNumber:LVL_IMAGES_CATEGORY__SUB_TYPE_COUNT]]);
}

- (NSString *) getRandomReferentColorArrayString
{
  
  return (self.lvl1_3_referentColorArr[[self getRandomNumber:LVL_IMAGES_CATEGORY__COLOR_COUNT]]);
}

- (NSString *) getRandomReferentImagePathAsString
{
  return [NSString stringWithFormat:@"%@%@%s%@", [self getRandomReferentTypeArrayString],
          [self getRandomReferentSubTypeArrayString],
          CHOICE_SELECTED_IMAGE_STR__CHOICE,
          [self getRandomReferentColorArrayString]];
}

- (void) loadNextView
{
  [self performSegueWithIdentifier:@"segue_levelOneThreeToLevelScoreSheet" sender:self];
  // load score sheet automatically
  ViewControllerLevelScoreSheet *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelScoreSheet"];
  [self presentViewController:vc animated:YES completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"segue_levelOneThreeToLevelScoreSheet"])
  {
    ViewControllerLevelScoreSheet *vc = (ViewControllerLevelScoreSheet *)segue.destinationViewController;
    vc.lvl_scoreSheet_recvUserName          = self.lvl_recvUserName;
    vc.lvl_scoreSheet_levelNumberPlayed     = LVL_PLAYED__ONE_THREE;
    vc.lvl_scoreSheet_glbRank               = 0;
    vc.lvl_scoreSheet_totalChoice           = self.lvl1_3_totalChoiceCount;
    vc.lvl_scoreSheet_totalCorrectAnswers   = self.lvl1_3_totalCorrectChoiceCount;
    vc.lvl_scoreSheet_incorrectAnswers      = (self.lvl1_3_totalChoiceCount - self.lvl1_3_totalCorrectChoiceCount);
    vc.lvl_scoreSheet_fastAnswers           = self.lvl1_3_totalCorrectFastCount;
    vc.lvl_scoreSheet_slowAnswers           = self.lvl1_3_totalCorrectSlowCount;
    vc.lvl_scoreSheet_okAnswers             = self.lvl1_3_totalCorrectOkCount;
    vc.lvl_scoreSheet_Accuracy              = 0;
    vc.lvl_scoreSheet_timeLeft              = self.lvl1_3_currMilliseconds;
    vc.lvl_scoreSheet_averageResponseTime   = (self.lvl1_3_responseMilliSeconds / self.lvl1_3_totalCorrectChoiceCount);
  }
}

@end
