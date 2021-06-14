//
//  ViewControllerLevelOneOne.m
//  Progress
//
//  Created by Sudhir Sawarkar on 11/6/15.
//  Copyright © 2015 Catamaran Labs. All rights reserved.
//

#import "ViewControllerLevelOneOne.h"
#import "ViewControllerLevelHome.h"
#import "DataStoreConfiguration.h"
#import "ViewControllerLevelScoreSheet.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewControllerLevelOneOne ()

// From Main-story board
@property (weak, nonatomic) IBOutlet UILabel *label_levelName;
@property (weak, nonatomic) IBOutlet UILabel *label_timeLeft;
@property (weak, nonatomic) IBOutlet UILabel *label_rewards;
@property (weak, nonatomic) IBOutlet UILabel *label_back;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView_correctCount;
@property (weak, nonatomic) IBOutlet UIButton *button_choiceBotRight;
@property (weak, nonatomic) IBOutlet UIButton *button_choiceBotLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_referent;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_animagedProgressBar;

// User defined
@property (nonatomic) int   lvl1_1_totalCorrectChoiceCount;
@property (nonatomic) int   lvl1_1_totalCorrectFastCount;
@property (nonatomic) int   lvl1_1_totalCorrectSlowCount;
@property (nonatomic) int   lvl1_1_totalCorrectOkCount;
@property (nonatomic) int   lvl1_1_totalChoiceCount;
@property (nonatomic) BOOL  lvl_1_1_countDownTimerRunningStatusFlag;
@property (nonatomic) float lvl1_1_progressViewCorrectCountValue;

@property (nonatomic) int lvl1_1_currMinute;
@property (nonatomic) int lvl1_1_currSeconds;
@property (nonatomic) int lvl1_1_currMilliseconds;
@property (nonatomic) int lvl1_1_prevMilliSeconds;
@property (nonatomic) int lvl1_1_responseMilliSeconds;
@property (strong, nonatomic) NSTimer *lvl1_1_countDownTimer;
@property (strong, nonatomic) NSDate  *lvl1_1_startDate;

@property (nonatomic, retain) NSArray *lvl1_1_referentTypeArr;
@property (nonatomic, retain) NSArray *lvl1_1_referentSubTypeArr;
@property (nonatomic, retain) NSArray *lvl1_1_referentColorArr;
@property (nonatomic, retain) NSArray *lvl1_1_progressBarImageArr;

@property (nonatomic) NSString *lvl1_1_referentImagePathAsString;
@property (nonatomic) NSString *lvl1_1_choiceBotLeftImagePathAsString;
@property (nonatomic) NSString *lvl1_1_choiceBotRightImagePathAsString;


//@property (nonatomic, strong) UIImageView *myImageView; // to be deleted

@end

@implementation ViewControllerLevelOneOne

@synthesize lvl1_1_totalCorrectChoiceCount,
            lvl1_1_totalCorrectFastCount,
            lvl1_1_totalCorrectSlowCount,
            lvl1_1_totalCorrectOkCount,
            lvl1_1_totalChoiceCount,
            lvl_1_1_countDownTimerRunningStatusFlag,
            lvl1_1_progressViewCorrectCountValue;

@synthesize lvl1_1_currMinute,
            lvl1_1_currSeconds,
            lvl1_1_currMilliseconds,
            lvl1_1_prevMilliSeconds,
            lvl1_1_responseMilliSeconds,
            lvl1_1_countDownTimer,
            lvl1_1_startDate;

@synthesize lvl1_1_referentTypeArr,
            lvl1_1_referentSubTypeArr,
            lvl1_1_progressBarImageArr,
            lvl1_1_referentColorArr;

@synthesize lvl1_1_referentImagePathAsString,
            lvl1_1_choiceBotLeftImagePathAsString,
            lvl1_1_choiceBotRightImagePathAsString;

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
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
  self.lvl1_1_referentTypeArr = [[NSArray alloc] initWithObjects:@"images/level_one/type_0",
                                                                 @"images/level_one/type_1",
                                                                 @"images/level_one/type_2",
                                                                 @"images/level_one/type_3",
                                                                 nil];

  self.lvl1_1_referentSubTypeArr = [[NSArray alloc] initWithObjects:@"/sub_type_0",
                                                                    @"/sub_type_1",
                                                                    @"/sub_type_2",
                                                                    @"/sub_type_3",
                                                                    @"/sub_type_4",
                                                                    @"/sub_type_5",
                                                                    @"/sub_type_6",
                                                                    @"/sub_type_7",
                                                                    nil];

  self.lvl1_1_referentColorArr = [[NSArray alloc] initWithObjects:@"/Blue.png",
                                                                  @"/Gray.png",
                                                                  @"/Green.png",
                                                                  @"/Orange.png",
                                                                  @"/Purple.png",
                                                                  @"/Red.png",
                                                                  @"/Yellow.png",
                                                                  nil];


  self.lvl1_1_progressBarImageArr = [[NSArray alloc] initWithObjects:@"images/progress_bar/progress_bar_percent_0.png",
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
  self.label_levelName.text = DEFAULT_EMPTY__STR;
  self.label_timeLeft.text  = DEFAULT_EMPTY__STR;
  self.label_rewards.text   = DEFAULT_EMPTY__STR;
  self.label_back.text      = DEFAULT_EMPTY__STR;
}

- (void) initCompnentsDefaults
{
  self.imageView_animagedProgressBar.image = [UIImage imageNamed:[lvl1_1_progressBarImageArr objectAtIndex:0]]; // 0 percent index
  
  [self.button_choiceBotLeft  setTitle:DEFAULT_EMPTY__STR forState:UIControlStateNormal];
  [self.button_choiceBotRight setTitle:DEFAULT_EMPTY__STR forState:UIControlStateNormal];
  self.label_levelName.text = @"LEVEL 1.1";
  self.label_timeLeft.text  = DEFAULT_TIME_LEFT_STR;
  self.label_rewards.text   = DEFAULT_EMPTY__STR;
  self.label_back.text      = DEFAULT_BACK_BUTTON_STR;
}

- (void) initLvlVariables
{
  self.lvl_1_1_countDownTimerRunningStatusFlag = NO;
  
  self.lvl1_1_currSeconds      = 0;
  self.lvl1_1_currMinute       = 0;
  self.lvl1_1_prevMilliSeconds = 0;
  self.lvl1_1_responseMilliSeconds = 0;
  self.lvl1_1_currMilliseconds = DEFAULT_CURR_MILLISECOND_LEFT_MS; // count down timer in milliseconds

  self.lvl1_1_totalChoiceCount        = 0;
  self.lvl1_1_totalCorrectChoiceCount = 0;
  self.lvl1_1_totalCorrectFastCount   = 0;
  self.lvl1_1_totalCorrectSlowCount   = 0;
  self.lvl1_1_totalCorrectOkCount     = 0;

  self.progressView_correctCount.progress = 0;
}

- (void) invalidateLvl
{
  [self.button_choiceBotLeft setEnabled:NO];
  [self.button_choiceBotRight setEnabled:NO];
  [self.lvl1_1_countDownTimer invalidate];
  self.lvl1_1_countDownTimer = nil;
  [self loadNextView];
}

- (void) updateCountDownTimer
{
  self.lvl1_1_currMilliseconds -= 10 ;

  int seconds = self.lvl1_1_currMilliseconds / 1000; // convert into seconds
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
  NSString * printTimer = [NSString stringWithFormat:@"%02d", self.lvl1_1_currMilliseconds/100];
  self.label_timeLeft.text = printTimer;

  //DONGcode - play 'time low' sound
  static bool playFlag = FALSE;

  if (playFlag == FALSE && self.lvl1_1_currMilliseconds < 4000)
  {
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"audio/Time low" ofType:@"aiff"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
    playFlag = TRUE;
  }
  
  // change color of downtime below < 20
  if (self.lvl1_1_currMilliseconds < 2000)
  {
    self.label_timeLeft.textColor = [UIColor redColor];
  }
  
  if (self.lvl1_1_currMilliseconds < 0)
  {
    [self invalidateLvl];
  }
}

- (void) updateRewardScore: (int) answerType
{
  if (answerType)
  {
    // correct answer
    self.lvl1_1_totalCorrectChoiceCount++; // increment correct count
    //self.label_rewards.text = @"";
   [self calculateResponseTime:self.lvl1_1_currMilliseconds];
    
    // play sound
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"audio/Right 2" ofType:@"aiff"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
  }
  else
  {
    self.lvl1_1_currMilliseconds -= LVL_ONE__RESPONSE_WRONG_TIMER_SUBSTRACT_MS;
    self.label_rewards.text = @"WRONG";
    //self.label_lvl1_answerResponseAddTime.text = @"-1";

    // play sound
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

  if (self.lvl1_1_responseMilliSeconds == 0)
  {
    referTime = DEFAULT_CURR_MILLISECOND_LEFT_MS;
  }
  
  self.lvl1_1_responseMilliSeconds += abs(currTime - referTime);
  referTime = currTime;
}

- (void) upDateRewardTimer:(int) rewardMilliSeconds
{
  if (rewardMilliSeconds < LVL_ONE__RESPONSE_FAST_TIMER_ADD_MS)
  {
    self.lvl1_1_currMilliseconds += LVL_ONE__REWARD_FAST_TIMER_ADD_MS;
    self.label_rewards.text = @"FAST";
    self.lvl1_1_totalCorrectFastCount++;
    //self.label_lvl1_answerResponseAddTime.text = @"+0.7";
    
  }
  else if (rewardMilliSeconds < LVL_ONE__RESPONSE_NORMAL_TIMER_ADD_MS)
  {
    self.lvl1_1_currMilliseconds += LVL_ONE__REWARD_NORMAL_TIMER_ADD_MS;
    self.label_rewards.text = @"GOOD";
    self.lvl1_1_totalCorrectOkCount++;
    //self.label_lvl1_answerResponseAddTime.text = @"+1.2";
  }
  else
  {
    self.lvl1_1_currMilliseconds += LVL_ONE__REWARD_SLOW_TIMER_ADD_MS;
    self.label_rewards.text = @"SLOW";
    self.lvl1_1_totalCorrectSlowCount++;
    //self.label_lvl1_answerResponseAddTime.text = @"+1.8";
  }
}

- (void) updateRewardProgressBar
{
  if (self.lvl1_1_totalChoiceCount <= LVL_ONE__PUZZLES_PER_LEVEL_MAX)
  {
    //float value = (float) self.lvl1_1_totalCorrectChoiceCount / LVL_ONE__PUZZLES_PER_LEVEL_MAX;
    //self.progressView_correctCount.progress = value; not used
    self.imageView_animagedProgressBar.image = [UIImage imageNamed:[lvl1_1_progressBarImageArr objectAtIndex:self.lvl1_1_totalCorrectChoiceCount]];
  }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonAction_choiceBotRight:(id)sender
{
  [self handleChoiceButtonAction:CHOICE_SELECTED__BOTTOM_RIGHT];
}

- (IBAction)buttonAction_choiceBotLeft:(id)sender
{
  [self handleChoiceButtonAction:CHOICE_SELECTED__BOTTOM_LEFT];
}

- (void) startCountDownTimer
{
  // if timer is not running; restart the timer here
  if (self.lvl_1_1_countDownTimerRunningStatusFlag == NO)
  {
    self.lvl_1_1_countDownTimerRunningStatusFlag = YES;
    self.lvl1_1_startDate = [NSDate date];
    self.lvl1_1_countDownTimer = [NSTimer scheduledTimerWithTimeInterval: .01
                                                                  target: self
                                                                selector: @selector(updateCountDownTimer)
                                                                userInfo: nil
                                                                 repeats: YES];
    self.lvl1_1_prevMilliSeconds = self.lvl1_1_currMilliseconds;
  }
}

- (void) handleChoiceButtonAction: (int) val
{
  int rewardMilliSeconds = 0;
 
  // if total referent image counter has exceeded the limit for current game
  if (self.lvl1_1_totalChoiceCount >= LVL_ONE__PUZZLES_PER_LEVEL_MAX)
  {
    [self invalidateLvl];
    return;
  }
  else
  {
    self.lvl1_1_totalChoiceCount++;
  }

  // based on the button pressed if correct reward time
  rewardMilliSeconds = self.lvl1_1_prevMilliSeconds - self.lvl1_1_currMilliseconds; //self.lvl1_currMilliSeconds(not count down timer hence diff sub)
  self.lvl1_1_prevMilliSeconds = self.lvl1_1_currMilliseconds;
  [self upDateRewardTimer:rewardMilliSeconds];

  // check which button is pressed
  if (val == CHOICE_SELECTED__BOTTOM_LEFT)
  {
    if([self.lvl1_1_referentImagePathAsString isEqualToString:self.lvl1_1_choiceBotLeftImagePathAsString])
    {
      //self.lvl1_1_choiceBotLeftImagePathAsString = [self.lvl1_1_choiceBotLeftImagePathAsString stringByReplacingOccurrencesOfString:@"choice"
      //                                                                                                                   withString:@"right"];
      // correct answer
      [self updateRewardScore:YES];
    }
    else
    {
      //self.lvl1_1_choiceBotLeftImagePathAsString = [self.lvl1_1_choiceBotLeftImagePathAsString stringByReplacingOccurrencesOfString:@"choice"
      //                                                                                                                   withString:@"wrong"];
      [self updateRewardScore:NO];
    }

    //NSLog(@"String %@", self.lvl1_1_referentImagePathAsString);
    //NSLog(@"Left %@", self.lvl1_1_choiceBotLeftImagePathAsString);
    //NSLog(@"Right %@", self.lvl1_1_choiceBotRightImagePathAsString);
  }
  else if (val == CHOICE_SELECTED__BOTTOM_RIGHT)
  {
    if([self.lvl1_1_referentImagePathAsString isEqualToString:self.lvl1_1_choiceBotRightImagePathAsString])
    {
      //NSLog(@"Hello 1 %@", self.lvl1_1_choiceBotRightImagePathAsString);
      //self.lvl1_1_choiceBotRightImagePathAsString = [self.lvl1_1_choiceBotRightImagePathAsString stringByReplacingOccurrencesOfString:@"choice"
      //                                                                                                                     withString:@"right"];

      //NSLog(@"Hello %@", self.lvl1_1_choiceBotRightImagePathAsString);
      //[self.button_choiceBotRight setImage:[UIImage imageNamed:self.lvl1_1_choiceBotRightImagePathAsString] forState:UIControlStateHighlighted];
      
      // correct answer
      [self updateRewardScore:YES];
    }
    else
    {
      //self.lvl1_1_choiceBotRightImagePathAsString = [self.lvl1_1_choiceBotRightImagePathAsString stringByReplacingOccurrencesOfString:@"choice"
      //                                                                                                                     withString:@"wrong"];
      [self updateRewardScore:NO];
    }
  }

  [self updateViewWithRandomImages];
}

- (void) updateViewWithRandomImages
{
  // select button on randomness
  int temp = arc4random() % LVL_ONE__CHOICE_BUTTON_TOTAL_COUNT;

  self.lvl1_1_referentImagePathAsString = [self getRandomReferentImagePathAsString];

  if (temp == 0)
  {
    self.lvl1_1_choiceBotLeftImagePathAsString  = self.lvl1_1_referentImagePathAsString;
    self.lvl1_1_choiceBotRightImagePathAsString = [self getRandomReferentImagePathAsString];
  }
  else if (temp == 1)
  {
    self.lvl1_1_choiceBotRightImagePathAsString = self.lvl1_1_referentImagePathAsString;
    self.lvl1_1_choiceBotLeftImagePathAsString  = [self getRandomReferentImagePathAsString];
  }

  // set referent image and choices
  self.imageView_referent.image = [UIImage imageNamed:self.lvl1_1_referentImagePathAsString];
  // set left choice image
  UIImage *left = [UIImage imageNamed:self.lvl1_1_choiceBotLeftImagePathAsString];
  [self.button_choiceBotLeft setBackgroundImage:left forState:UIControlStateNormal];
  // set right choice image
  UIImage *right = [UIImage imageNamed:self.lvl1_1_choiceBotRightImagePathAsString];
  [self.button_choiceBotRight setBackgroundImage:right forState:UIControlStateNormal];
}

- (int) getRandomNumber: (int) maxValue
{
  return (arc4random() % maxValue);
}

- (NSString *) getRandomReferentTypeArrayString
{
  
  return (self.lvl1_1_referentTypeArr[[self getRandomNumber:LVL_IMAGES_CATEGORY__TYPE_COUNT]]);
}

- (NSString *) getRandomReferentSubTypeArrayString
{
  
  return (self.lvl1_1_referentSubTypeArr[[self getRandomNumber:LVL_IMAGES_CATEGORY__SUB_TYPE_COUNT]]);
}

- (NSString *) getRandomReferentColorArrayString
{
  
  return (self.lvl1_1_referentColorArr[[self getRandomNumber:LVL_IMAGES_CATEGORY__COLOR_COUNT]]);
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
  /* DONGcode - this code is bad and we should feel bad!
  // play sound
  SystemSoundID soundID;
  
  NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"audio/Right 3" ofType:@"aiff"];
  NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
  
  AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
  AudioServicesPlaySystemSound(soundID);
  */
  
  [self performSegueWithIdentifier:@"segue_levelOneOneToLevelScoreSheet" sender:self];
  // load score sheet automatically
  ViewControllerLevelScoreSheet *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelScoreSheet"];
  [self presentViewController:vc animated:YES completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"segue_levelOneOneToLevelScoreSheet"])
  {
    ViewControllerLevelScoreSheet *vc = (ViewControllerLevelScoreSheet *)segue.destinationViewController;
    vc.lvl_scoreSheet_recvUserName          = self.lvl_recvUserName;
    vc.lvl_scoreSheet_levelNumberPlayed     = LVL_PLAYED__ONE_ONE;
    vc.lvl_scoreSheet_glbRank               = 0;
    vc.lvl_scoreSheet_totalChoice           = self.lvl1_1_totalChoiceCount;
    vc.lvl_scoreSheet_totalCorrectAnswers   = self.lvl1_1_totalCorrectChoiceCount;
    vc.lvl_scoreSheet_incorrectAnswers      = (self.lvl1_1_totalChoiceCount - self.lvl1_1_totalCorrectChoiceCount);
    vc.lvl_scoreSheet_fastAnswers           = self.lvl1_1_totalCorrectFastCount;
    vc.lvl_scoreSheet_slowAnswers           = self.lvl1_1_totalCorrectSlowCount;
    vc.lvl_scoreSheet_okAnswers             = self.lvl1_1_totalCorrectOkCount;
    vc.lvl_scoreSheet_Accuracy              = 0;
    vc.lvl_scoreSheet_timeLeft              = self.lvl1_1_currMilliseconds;
    vc.lvl_scoreSheet_averageResponseTime   = (self.lvl1_1_responseMilliSeconds / self.lvl1_1_totalCorrectChoiceCount);
  }
}

@end
