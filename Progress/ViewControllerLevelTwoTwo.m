//
//  ViewControllerLevelTwoTwo.m
//  Progress
//
//  Created by Sudhir Sawarkar on 11/13/15.
//  Copyright © 2015 Catamaran Labs. All rights reserved.
//

#import "ViewControllerLevelTwoTwo.h"
#import "ViewControllerLevelHome.h"
#import "DataStoreConfiguration.h"
#import "ViewControllerLevelScoreSheet.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewControllerLevelTwoTwo ()

// From Main-story board
@property (weak, nonatomic) IBOutlet UILabel *label_levelName;
@property (weak, nonatomic) IBOutlet UILabel *label_timeLeft;
@property (weak, nonatomic) IBOutlet UILabel *label_rewards;
@property (weak, nonatomic) IBOutlet UILabel *label_back;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_animagedProgressBar;

@property (weak, nonatomic) IBOutlet UIImageView *imageView_referent_0;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_referent_1;

@property (weak, nonatomic) IBOutlet UIButton *button_choice_0;
@property (weak, nonatomic) IBOutlet UIButton *button_choice_1;
@property (weak, nonatomic) IBOutlet UIButton *button_choice_2;
@property (weak, nonatomic) IBOutlet UIButton *button_choice_3;
@property (weak, nonatomic) IBOutlet UIButton *button_choice_4;
@property (weak, nonatomic) IBOutlet UIButton *button_choice_5;
@property (weak, nonatomic) IBOutlet UIButton *button_choice_6;
@property (weak, nonatomic) IBOutlet UIButton *button_choice_7;
@property (weak, nonatomic) IBOutlet UIButton *button_choice_8;
@property (weak, nonatomic) IBOutlet UIButton *button_choice_9;
@property (weak, nonatomic) IBOutlet UIButton *button_choice_10;

// User defined
@property (nonatomic) int   lvl_totalCorrectChoiceCount;
@property (nonatomic) int   lvl_totalCorrectFastCount;
@property (nonatomic) int   lvl_totalCorrectSlowCount;
@property (nonatomic) int   lvl_totalCorrectOkCount;
@property (nonatomic) int   lvl_totalChoiceCount;
@property (nonatomic) BOOL  lvl_countDownTimerRunningStatusFlag;
@property (nonatomic) float lvl_progressViewCorrectCountValue;

@property (nonatomic) int lvl_currMinute;
@property (nonatomic) int lvl_currSeconds;
@property (nonatomic) int lvl_currMilliseconds;
@property (nonatomic) int lvl_prevMilliSeconds;
@property (nonatomic) int lvl_responseMilliSeconds;

@property (strong, nonatomic) NSTimer *lvl_countDownTimer;
@property (strong, nonatomic) NSDate  *lvl_startDate;

@property (nonatomic, retain) NSArray *lvl_referentTypeArr;
@property (nonatomic, retain) NSArray *lvl_referentSubTypeArr;
@property (nonatomic, retain) NSArray *lvl_referentColorArr;
@property (nonatomic, retain) NSArray *lvl_progressBarImageArr;

@property (nonatomic, retain) NSMutableArray *lvl_referentImagePathStringSavedArr;
@property (nonatomic, retain) NSMutableArray *lvl_choiceImagePathStringSavedArr;

@end

@implementation ViewControllerLevelTwoTwo

@synthesize lvl_totalCorrectChoiceCount,
lvl_totalCorrectFastCount,
lvl_totalCorrectSlowCount,
lvl_totalCorrectOkCount,
lvl_totalChoiceCount,
lvl_countDownTimerRunningStatusFlag,
lvl_progressViewCorrectCountValue;

@synthesize lvl_currMinute,
lvl_currSeconds,
lvl_currMilliseconds,
lvl_prevMilliSeconds,
lvl_responseMilliSeconds,
lvl_countDownTimer,
lvl_startDate;

@synthesize lvl_referentTypeArr,
lvl_referentSubTypeArr,
lvl_progressBarImageArr,
lvl_referentColorArr;

@synthesize lvl_referentImagePathStringSavedArr,
lvl_choiceImagePathStringSavedArr;

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
  imgView.image = [UIImage imageNamed:@"images/game_screen/SWIPE_launch.png"];
  [self.view addSubview:imgView];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    imgView.image = nil;
    [self addTapGestures];
    [self componentsActivate:NO];
    [self addDragGestureToAllChoiceButton];
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
  self.button_choice_0.hidden               = status;
  self.button_choice_1.hidden               = status;
  self.button_choice_2.hidden               = status;
  self.button_choice_3.hidden               = status;
  self.button_choice_4.hidden               = status;
  self.button_choice_5.hidden               = status;
  self.button_choice_6.hidden               = status;
  self.button_choice_7.hidden               = status;
  self.button_choice_8.hidden               = status;
  self.button_choice_9.hidden               = status;
  self.button_choice_10.hidden              = status;
  self.imageView_referent_0.hidden          = status;
  self.imageView_referent_1.hidden          = status;
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
  self.lvl_referentTypeArr = [[NSArray alloc] initWithObjects:@"images/level_one/type_0",
                              @"images/level_one/type_1",
                              @"images/level_one/type_2",
                              @"images/level_one/type_3",
                              nil];
  
  self.lvl_referentSubTypeArr = [[NSArray alloc] initWithObjects:@"/sub_type_0",
                                 @"/sub_type_1",
                                 @"/sub_type_2",
                                 @"/sub_type_3",
                                 @"/sub_type_4",
                                 @"/sub_type_5",
                                 @"/sub_type_6",
                                 @"/sub_type_7",
                                 nil];
  
  self.lvl_referentColorArr = [[NSArray alloc] initWithObjects:@"/Blue.png",
                               @"/Gray.png",
                               @"/Green.png",
                               @"/Orange.png",
                               @"/Purple.png",
                               @"/Red.png",
                               @"/Yellow.png",
                               nil];
  
  
  self.lvl_progressBarImageArr = [[NSArray alloc] initWithObjects:@"images/progress_bar/progress_bar_percent_0.png",
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
  
  self.lvl_referentImagePathStringSavedArr = [[NSMutableArray alloc] initWithCapacity:LVL_TWO_TWO__IMAGE_REFERENT_TOTAL_COUNT];
  self.lvl_choiceImagePathStringSavedArr   = [[NSMutableArray alloc] initWithCapacity:LVL_TWO_TWO__CHOICE_BUTTON_TOTAL_COUNT];
}

- (void) initCompnentsDefaultsAtLoadUp
{
  self.imageView_animagedProgressBar.image = nil;
  
  [self.button_choice_0 setTitle:@"" forState:UIControlStateNormal];
  [self.button_choice_1 setTitle:@"" forState:UIControlStateNormal];
  [self.button_choice_2 setTitle:@"" forState:UIControlStateNormal];
  [self.button_choice_3 setTitle:@"" forState:UIControlStateNormal];
  [self.button_choice_4 setTitle:@"" forState:UIControlStateNormal];
  [self.button_choice_5 setTitle:@"" forState:UIControlStateNormal];
  [self.button_choice_6 setTitle:@"" forState:UIControlStateNormal];
  [self.button_choice_7 setTitle:@"" forState:UIControlStateNormal];
  [self.button_choice_8 setTitle:@"" forState:UIControlStateNormal];
  [self.button_choice_9 setTitle:@"" forState:UIControlStateNormal];
  [self.button_choice_10 setTitle:@"" forState:UIControlStateNormal];
  
  self.label_levelName.text = DEFAULT_EMPTY__STR;
  self.label_timeLeft.text  = DEFAULT_EMPTY__STR;
  self.label_rewards.text   = DEFAULT_EMPTY__STR;
  self.label_back.text      = DEFAULT_EMPTY__STR;
}

- (void) initCompnentsDefaults
{
  self.imageView_animagedProgressBar.image = [UIImage imageNamed:[self.lvl_progressBarImageArr objectAtIndex:0]]; // 0 percent index
  
  [self.button_choice_0 setTitle:@"button_choice_0" forState:UIControlStateNormal];
  [self.button_choice_1 setTitle:@"button_choice_1" forState:UIControlStateNormal];
  [self.button_choice_2 setTitle:@"button_choice_2" forState:UIControlStateNormal];
  [self.button_choice_3 setTitle:@"button_choice_3" forState:UIControlStateNormal];
  [self.button_choice_4 setTitle:@"button_choice_4" forState:UIControlStateNormal];
  [self.button_choice_5 setTitle:@"button_choice_5" forState:UIControlStateNormal];
  [self.button_choice_6 setTitle:@"button_choice_6" forState:UIControlStateNormal];
  [self.button_choice_7 setTitle:@"button_choice_7" forState:UIControlStateNormal];
  [self.button_choice_8 setTitle:@"button_choice_8" forState:UIControlStateNormal];
  [self.button_choice_9 setTitle:@"button_choice_9" forState:UIControlStateNormal];
  [self.button_choice_10 setTitle:@"button_choice_10" forState:UIControlStateNormal];
  
  self.button_choice_0.titleLabel.layer.opacity = 0.0f;
  self.button_choice_1.titleLabel.layer.opacity = 0.0f;
  self.button_choice_2.titleLabel.layer.opacity = 0.0f;
  self.button_choice_3.titleLabel.layer.opacity = 0.0f;
  self.button_choice_4.titleLabel.layer.opacity = 0.0f;
  self.button_choice_5.titleLabel.layer.opacity = 0.0f;
  self.button_choice_6.titleLabel.layer.opacity = 0.0f;
  self.button_choice_7.titleLabel.layer.opacity = 0.0f;
  self.button_choice_8.titleLabel.layer.opacity = 0.0f;
  self.button_choice_9.titleLabel.layer.opacity = 0.0f;
  self.button_choice_10.titleLabel.layer.opacity = 0.0f;
  
  self.label_levelName.text = @"LEVEL 2.2";
  self.label_timeLeft.text  = DEFAULT_TIME_LEFT_STR;
  self.label_rewards.text   = DEFAULT_EMPTY__STR;
  self.label_back.text      = DEFAULT_BACK_BUTTON_STR;
}

- (void) initLvlVariables
{
  self.lvl_countDownTimerRunningStatusFlag = NO;
  
  self.lvl_currSeconds      = 0;
  self.lvl_currMinute       = 0;
  self.lvl_prevMilliSeconds = 0;
  self.lvl_responseMilliSeconds = 0;
  self.lvl_currMilliseconds = LVL_TWO_DEFAULT_CURR_MILLISECOND_LEFT_MS; // count down timer in milliseconds
  
  self.lvl_totalChoiceCount        = 0;
  self.lvl_totalCorrectChoiceCount = 0;
  self.lvl_totalCorrectFastCount   = 0;
  self.lvl_totalCorrectSlowCount   = 0;
  self.lvl_totalCorrectOkCount     = 0;
}

- (void) addDragGestureToAllChoiceButton
{
  [self.button_choice_0 addTarget:self action:@selector(dragOut:withEvent:) forControlEvents:UIControlEventTouchDragOutside];// | UIControlEventTouchDragInside];
  [self.button_choice_1 addTarget:self action:@selector(dragOut:withEvent:) forControlEvents:UIControlEventTouchDragOutside];// | UIControlEventTouchDragInside];
  [self.button_choice_2 addTarget:self action:@selector(dragOut:withEvent:) forControlEvents:UIControlEventTouchDragOutside];// | UIControlEventTouchDragInside];
  [self.button_choice_3 addTarget:self action:@selector(dragOut:withEvent:) forControlEvents:UIControlEventTouchDragOutside];// | UIControlEventTouchDragInside];
  [self.button_choice_4 addTarget:self action:@selector(dragOut:withEvent:) forControlEvents:UIControlEventTouchDragOutside];// | UIControlEventTouchDragInside];
  [self.button_choice_5 addTarget:self action:@selector(dragOut:withEvent:) forControlEvents:UIControlEventTouchDragOutside];// | UIControlEventTouchDragInside];
  [self.button_choice_6 addTarget:self action:@selector(dragOut:withEvent:) forControlEvents:UIControlEventTouchDragOutside];// | UIControlEventTouchDragInside];
  [self.button_choice_7 addTarget:self action:@selector(dragOut:withEvent:) forControlEvents:UIControlEventTouchDragOutside];// | UIControlEventTouchDragInside];
  [self.button_choice_8 addTarget:self action:@selector(dragOut:withEvent:) forControlEvents:UIControlEventTouchDragOutside];// | UIControlEventTouchDragInside];
  [self.button_choice_9 addTarget:self action:@selector(dragOut:withEvent:) forControlEvents:UIControlEventTouchDragOutside];// | UIControlEventTouchDragInside];
  [self.button_choice_10 addTarget:self action:@selector(dragOut:withEvent:) forControlEvents:UIControlEventTouchDragOutside];// | UIControlEventTouchDragInside];
}

- (void) invalidateLvl
{
  [self.button_choice_0 setEnabled:NO];
  [self.button_choice_1 setEnabled:NO];
  [self.button_choice_2 setEnabled:NO];
  [self.button_choice_3 setEnabled:NO];
  [self.button_choice_4 setEnabled:NO];
  [self.button_choice_5 setEnabled:NO];
  [self.button_choice_6 setEnabled:NO];
  [self.button_choice_7 setEnabled:NO];
  [self.button_choice_8 setEnabled:NO];
  [self.button_choice_9 setEnabled:NO];
  [self.button_choice_10 setEnabled:NO];
  
  [self.lvl_countDownTimer invalidate];
  self.lvl_countDownTimer = nil;
  [self loadNextView];
}

- (void) updateCountDownTimer
{
  self.lvl_currMilliseconds -= 10 ;
  
  int seconds = self.lvl_currMilliseconds / 1000;
  int minutes = seconds / 60;
  int hours   = minutes / 60;
  
  seconds -= minutes * 60;
  minutes -= hours * 60;
  
  NSString * printTimer = [NSString stringWithFormat:@"%02d", self.lvl_currMilliseconds/100];
  self.label_timeLeft.text = printTimer;
  
  //DONGcode - play sound 'Time Low'
  static bool playFlag = FALSE;
  
  if (playFlag == FALSE && self.lvl_currMilliseconds < 4000)
  {
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"audio/Time low" ofType:@"aiff"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
    playFlag = TRUE;
  }
  
  // change color of downtime below < 20
  if (self.lvl_currMilliseconds < 2000)
  {
    self.label_timeLeft.textColor = [UIColor redColor];
  }
  
  if (self.lvl_currMilliseconds < 0)
  {
    [self invalidateLvl];
  }
}

- (void) updateRewardScore: (int) answerType
{
  if (answerType)
  {
    // correct answer
    self.lvl_totalCorrectChoiceCount++; // increment correct count
    //self.label_rewards.text = @"";
    [self calculateResponseTime:self.lvl_currMilliseconds];
    
    //DONGcode - play sound 'Right Choice'
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"audio/Right 2" ofType:@"aiff"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
  }
  else
  {
    self.lvl_currMilliseconds -= LVL_TWO__RESPONSE_WRONG_TIMER_SUBSTRACT_MS;
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
  static int referTime = LVL_TWO_DEFAULT_CURR_MILLISECOND_LEFT_MS;
  
  if (self.lvl_responseMilliSeconds == 0)
  {
    referTime = LVL_TWO_DEFAULT_CURR_MILLISECOND_LEFT_MS;
  }
  
  self.lvl_responseMilliSeconds += abs(currTime - referTime);
  referTime = currTime;
}

- (void) upDateRewardTimer:(int) rewardMilliSeconds
{
  if (rewardMilliSeconds < LVL_TWO__RESPONSE_FAST_TIMER_ADD_MS)
  {
    self.lvl_currMilliseconds += LVL_TWO__REWARD_FAST_TIMER_ADD_MS;
    self.label_rewards.text = @"FAST";
    self.lvl_totalCorrectFastCount++;
    //self.label_lvl1_answerResponseAddTime.text = @"+0.7";
    
  }
  else if (rewardMilliSeconds < LVL_TWO__RESPONSE_NORMAL_TIMER_ADD_MS)
  {
    self.lvl_currMilliseconds += LVL_TWO__REWARD_NORMAL_TIMER_ADD_MS;
    self.label_rewards.text = @"GOOD";
    self.lvl_totalCorrectOkCount++;
    //self.label_lvl1_answerResponseAddTime.text = @"+1.2";
  }
  else
  {
    self.lvl_currMilliseconds += LVL_TWO__REWARD_SLOW_TIMER_ADD_MS;
    self.label_rewards.text = @"SLOW";
    self.lvl_totalCorrectSlowCount++;
    //self.label_lvl1_answerResponseAddTime.text = @"+1.8";
  }
}

- (void) updateRewardProgressBar
{
  if (self.lvl_totalChoiceCount <= LVL_TWO_TWO__PUZZLES_PER_LEVEL_MAX)
  {
    self.imageView_animagedProgressBar.image = [UIImage imageNamed:[lvl_progressBarImageArr objectAtIndex:self.lvl_totalCorrectChoiceCount]];
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

- (void) startCountDownTimer
{
  // if timer is not running; restart the timer here
  if (self.lvl_countDownTimerRunningStatusFlag == NO)
  {
    self.lvl_countDownTimerRunningStatusFlag = YES;
    self.lvl_startDate = [NSDate date];
    self.lvl_countDownTimer = [NSTimer scheduledTimerWithTimeInterval: .01
                                                               target: self
                                                             selector: @selector(updateCountDownTimer)
                                                             userInfo: nil
                                                              repeats: YES];
    self.lvl_prevMilliSeconds = self.lvl_currMilliseconds;
  }
}

-(IBAction)dragOut: (id)sender withEvent: (UIEvent *) event
{
  static int dragCount = 0;
  static NSString* prevButtonStr = @"";
  int rewardMilliSeconds = 0;
  
  UIButton *selected = (UIButton *)sender;
  selected.center = [[[event allTouches] anyObject] locationInView:self.view];
  
  if ([prevButtonStr isEqualToString:selected.currentTitle])
  {
    return;
  }
  else
  {
    prevButtonStr = selected.currentTitle;
  }
  
  NSString* butttonStr = prevButtonStr;
  
  if ([butttonStr isEqualToString:@"button_choice_0"])
  {
    if  ([self.lvl_choiceImagePathStringSavedArr[0] isEqualToString:self.lvl_referentImagePathStringSavedArr[0]]
         || [self.lvl_choiceImagePathStringSavedArr[0] isEqualToString:self.lvl_referentImagePathStringSavedArr[1]])
    {
      self.lvl_choiceImagePathStringSavedArr[0] = [self.lvl_choiceImagePathStringSavedArr[0] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"right"];
      self.button_choice_0.selected = YES;
      dragCount++;
    }
    else
    {
      self.lvl_choiceImagePathStringSavedArr[0] = [self.lvl_choiceImagePathStringSavedArr[0] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"wrong"];
      self.button_choice_0.selected = NO;
    }
    
    // update choice image 0
    UIImage *choice_0 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:0]];
    [self.button_choice_0 setBackgroundImage:choice_0 forState:UIControlStateNormal];
  }
  
  
  if ([butttonStr isEqualToString:@"button_choice_1"])
  {
    if  ([self.lvl_choiceImagePathStringSavedArr[1] isEqualToString:self.lvl_referentImagePathStringSavedArr[0]]
         || [self.lvl_choiceImagePathStringSavedArr[1] isEqualToString:self.lvl_referentImagePathStringSavedArr[1]])
    {
      self.lvl_choiceImagePathStringSavedArr[1] = [self.lvl_choiceImagePathStringSavedArr[1] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"right"];
      self.button_choice_1.selected = YES;
      dragCount++;
    }
    else
    {
      self.lvl_choiceImagePathStringSavedArr[1] = [self.lvl_choiceImagePathStringSavedArr[1] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"wrong"];
      self.button_choice_1.selected = NO;
    }
    
    // update choice image 1
    UIImage *choice_1 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:1]];
    [self.button_choice_1 setBackgroundImage:choice_1 forState:UIControlStateNormal];
  }
  
  
  if ([butttonStr isEqualToString:@"button_choice_2"])
  {
    if  ([self.lvl_choiceImagePathStringSavedArr[2] isEqualToString:self.lvl_referentImagePathStringSavedArr[0]]
         || [self.lvl_choiceImagePathStringSavedArr[2] isEqualToString:self.lvl_referentImagePathStringSavedArr[1]])
    {
      self.lvl_choiceImagePathStringSavedArr[2] = [self.lvl_choiceImagePathStringSavedArr[2] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"right"];
      self.button_choice_2.selected = YES;
      dragCount++;
    }
    else
    {
      self.lvl_choiceImagePathStringSavedArr[2] = [self.lvl_choiceImagePathStringSavedArr[2] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"wrong"];
      self.button_choice_2.selected = NO;
    }
    
    // update choice image 2
    UIImage *choice_2 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:2]];
    [self.button_choice_2 setBackgroundImage:choice_2 forState:UIControlStateNormal];
  }
  
  
  if ([butttonStr isEqualToString:@"button_choice_3"])
  {
    if  ([self.lvl_choiceImagePathStringSavedArr[3] isEqualToString:self.lvl_referentImagePathStringSavedArr[0]]
         || [self.lvl_choiceImagePathStringSavedArr[3] isEqualToString:self.lvl_referentImagePathStringSavedArr[1]])
    {
      self.lvl_choiceImagePathStringSavedArr[3] = [self.lvl_choiceImagePathStringSavedArr[3] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"right"];
      self.button_choice_3.selected = YES;
      dragCount++;
    }
    else
    {
      self.lvl_choiceImagePathStringSavedArr[3] = [self.lvl_choiceImagePathStringSavedArr[3] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"wrong"];
      self.button_choice_3.selected = NO;
    }
    
    // update choice image 3
    UIImage *choice_3 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:3]];
    [self.button_choice_3 setBackgroundImage:choice_3 forState:UIControlStateNormal];
  }
  
  
  if ([butttonStr isEqualToString:@"button_choice_4"])
  {
    if  ([self.lvl_choiceImagePathStringSavedArr[4] isEqualToString:self.lvl_referentImagePathStringSavedArr[0]]
         || [self.lvl_choiceImagePathStringSavedArr[4] isEqualToString:self.lvl_referentImagePathStringSavedArr[1]])
    {
      self.lvl_choiceImagePathStringSavedArr[4] = [self.lvl_choiceImagePathStringSavedArr[4] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"right"];
      self.button_choice_4.selected = YES;
      dragCount++;
    }
    else
    {
      self.lvl_choiceImagePathStringSavedArr[4] = [self.lvl_choiceImagePathStringSavedArr[4] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"wrong"];
      self.button_choice_4.selected = NO;
    }
    
    // update choice image 4
    UIImage *choice_4 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:4]];
    [self.button_choice_4 setBackgroundImage:choice_4 forState:UIControlStateNormal];
  }
  
  
  if ([butttonStr isEqualToString:@"button_choice_5"])
  {
    if  ([self.lvl_choiceImagePathStringSavedArr[5] isEqualToString:self.lvl_referentImagePathStringSavedArr[0]]
         || [self.lvl_choiceImagePathStringSavedArr[5] isEqualToString:self.lvl_referentImagePathStringSavedArr[1]])
    {
      self.lvl_choiceImagePathStringSavedArr[5] = [self.lvl_choiceImagePathStringSavedArr[5] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"right"];
      self.button_choice_5.selected = YES;
      dragCount++;
    }
    else
    {
      self.lvl_choiceImagePathStringSavedArr[5] = [self.lvl_choiceImagePathStringSavedArr[5] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"wrong"];
      self.button_choice_5.selected = NO;
    }
    
    // update choice image 5
    UIImage *choice_5 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:5]];
    [self.button_choice_5 setBackgroundImage:choice_5 forState:UIControlStateNormal];
  }
  
  if ([butttonStr isEqualToString:@"button_choice_6"])
  {
    if  ([self.lvl_choiceImagePathStringSavedArr[6] isEqualToString:self.lvl_referentImagePathStringSavedArr[0]]
         || [self.lvl_choiceImagePathStringSavedArr[6] isEqualToString:self.lvl_referentImagePathStringSavedArr[1]])
    {
      self.lvl_choiceImagePathStringSavedArr[6] = [self.lvl_choiceImagePathStringSavedArr[6] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"right"];
      self.button_choice_6.selected = YES;
      dragCount++;
    }
    else
    {
      self.lvl_choiceImagePathStringSavedArr[6] = [self.lvl_choiceImagePathStringSavedArr[6] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"wrong"];
      self.button_choice_6.selected = NO;
    }
    
    // update choice image 5
    UIImage *choice_6 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:6]];
    [self.button_choice_6 setBackgroundImage:choice_6 forState:UIControlStateNormal];
  }
  
  if ([butttonStr isEqualToString:@"button_choice_7"])
  {
    if  ([self.lvl_choiceImagePathStringSavedArr[7] isEqualToString:self.lvl_referentImagePathStringSavedArr[0]]
         || [self.lvl_choiceImagePathStringSavedArr[7] isEqualToString:self.lvl_referentImagePathStringSavedArr[1]])
    {
      self.lvl_choiceImagePathStringSavedArr[7] = [self.lvl_choiceImagePathStringSavedArr[7] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"right"];
      self.button_choice_7.selected = YES;
      dragCount++;
    }
    else
    {
      self.lvl_choiceImagePathStringSavedArr[7] = [self.lvl_choiceImagePathStringSavedArr[7] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"wrong"];
      self.button_choice_7.selected = NO;
    }
    
    // update choice image 7
    UIImage *choice_7 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:7]];
    [self.button_choice_7 setBackgroundImage:choice_7 forState:UIControlStateNormal];
  }
  
  if ([butttonStr isEqualToString:@"button_choice_8"])
  {
    if  ([self.lvl_choiceImagePathStringSavedArr[8] isEqualToString:self.lvl_referentImagePathStringSavedArr[0]]
         || [self.lvl_choiceImagePathStringSavedArr[8] isEqualToString:self.lvl_referentImagePathStringSavedArr[1]])
    {
      self.lvl_choiceImagePathStringSavedArr[8] = [self.lvl_choiceImagePathStringSavedArr[8] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"right"];
      self.button_choice_8.selected = YES;
      dragCount++;
    }
    else
    {
      self.lvl_choiceImagePathStringSavedArr[8] = [self.lvl_choiceImagePathStringSavedArr[8] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"wrong"];
      self.button_choice_8.selected = NO;
    }
    
    // update choice image 8
    UIImage *choice_8 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:8]];
    [self.button_choice_8 setBackgroundImage:choice_8 forState:UIControlStateNormal];
  }
  
  if ([butttonStr isEqualToString:@"button_choice_9"])
  {
    if  ([self.lvl_choiceImagePathStringSavedArr[9] isEqualToString:self.lvl_referentImagePathStringSavedArr[0]]
         || [self.lvl_choiceImagePathStringSavedArr[9] isEqualToString:self.lvl_referentImagePathStringSavedArr[1]])
    {
      self.lvl_choiceImagePathStringSavedArr[9] = [self.lvl_choiceImagePathStringSavedArr[9] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"right"];
      self.button_choice_9.selected = YES;
      dragCount++;
    }
    else
    {
      self.lvl_choiceImagePathStringSavedArr[9] = [self.lvl_choiceImagePathStringSavedArr[9] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"wrong"];
      self.button_choice_9.selected = NO;
    }
    
    // update choice image 9
    UIImage *choice_9 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:9]];
    [self.button_choice_9 setBackgroundImage:choice_9 forState:UIControlStateNormal];
  }
  
  if ([butttonStr isEqualToString:@"button_choice_10"])
  {
    if  ([self.lvl_choiceImagePathStringSavedArr[10] isEqualToString:self.lvl_referentImagePathStringSavedArr[0]]
         || [self.lvl_choiceImagePathStringSavedArr[10] isEqualToString:self.lvl_referentImagePathStringSavedArr[1]])
    {
      self.lvl_choiceImagePathStringSavedArr[10] = [self.lvl_choiceImagePathStringSavedArr[10] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"right"];
      self.button_choice_10.selected = YES;
      dragCount++;
    }
    else
    {
      self.lvl_choiceImagePathStringSavedArr[10] = [self.lvl_choiceImagePathStringSavedArr[10] stringByReplacingOccurrencesOfString:@"choice"
                                                                                                                       withString:@"wrong"];
      self.button_choice_10.selected = NO;
    }
    
    // update choice image 10
    UIImage *choice_10 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:10]];
    [self.button_choice_10 setBackgroundImage:choice_10 forState:UIControlStateNormal];
  }
  
  if (dragCount >= LVL_TWO_TWO__IMAGE_REFERENT_TOTAL_COUNT)
  {
    dragCount = 0;
    //prevButtonStr = @"";
    
    // if total referent image counter has exceeded the limit for current game
    if (self.lvl_totalChoiceCount >= LVL_TWO_TWO__PUZZLES_PER_LEVEL_MAX)
    {
      [self invalidateLvl];
      return;
    }
    else
    {
      self.lvl_totalChoiceCount++;
    }
    
    // based on the button pressed if correct reward time
    rewardMilliSeconds = self.lvl_prevMilliSeconds - self.lvl_currMilliseconds; //self.lvl1_currMilliSeconds(not count down timer hence diff sub)
    self.lvl_prevMilliSeconds = self.lvl_currMilliseconds;
    [self upDateRewardTimer:rewardMilliSeconds];
    [self updateViewWithRandomImages];
    [self updateRewardScore:1];
  }
}

- (void) updateViewWithRandomImages
{
  for (UInt8 i = 0; i < LVL_TWO_TWO__IMAGE_REFERENT_TOTAL_COUNT; i++)
  {
    self.lvl_referentImagePathStringSavedArr[i] = [self getRandomReferentImagePathAsString];
  }
  
  for (UInt8 i = 0; i < LVL_TWO_TWO__CHOICE_BUTTON_TOTAL_COUNT; i++)
  {
    if (i < LVL_TWO_TWO__IMAGE_REFERENT_TOTAL_COUNT)
    {
      self.lvl_choiceImagePathStringSavedArr[i] = self.lvl_referentImagePathStringSavedArr[i];
    }
    else
    {
      self.lvl_choiceImagePathStringSavedArr[i] = [self getRandomReferentImagePathAsString];
    }
  }
  
  NSUInteger count = [self.lvl_choiceImagePathStringSavedArr count];
  for (NSUInteger i = 0; i < count - 1; ++i)
  {
    NSInteger remainingCount = count - i;
    NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
    [self.lvl_choiceImagePathStringSavedArr exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
  }
  
  // set referent image and choices
  self.imageView_referent_0.image = [UIImage imageNamed:[self.lvl_referentImagePathStringSavedArr objectAtIndex:0]];
  self.imageView_referent_1.image = [UIImage imageNamed:[self.lvl_referentImagePathStringSavedArr objectAtIndex:1]];
  // update choice image 0
  UIImage *choice_0 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:0]];
  [self.button_choice_0 setBackgroundImage:choice_0 forState:UIControlStateNormal];
  // update choice image 1
  UIImage *choice_1 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:1]];
  [self.button_choice_1 setBackgroundImage:choice_1 forState:UIControlStateNormal];
  // update choice image 2
  UIImage *choice_2 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:2]];
  [self.button_choice_2 setBackgroundImage:choice_2 forState:UIControlStateNormal];
  // update choice image 3
  UIImage *choice_3 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:3]];
  [self.button_choice_3 setBackgroundImage:choice_3 forState:UIControlStateNormal];
  // update choice image 4
  UIImage *choice_4 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:4]];
  [self.button_choice_4 setBackgroundImage:choice_4 forState:UIControlStateNormal];
  // update choice image 5
  UIImage *choice_5 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:5]];
  [self.button_choice_5 setBackgroundImage:choice_5 forState:UIControlStateNormal];
  // update choice image 6
  UIImage *choice_6 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:6]];
  [self.button_choice_6 setBackgroundImage:choice_6 forState:UIControlStateNormal];
  // update choice image 7
  UIImage *choice_7 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:7]];
  [self.button_choice_7 setBackgroundImage:choice_7 forState:UIControlStateNormal];
  // update choice image 8
  UIImage *choice_8 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:8]];
  [self.button_choice_8 setBackgroundImage:choice_8 forState:UIControlStateNormal];
  // update choice image 9
  UIImage *choice_9 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:9]];
  [self.button_choice_9 setBackgroundImage:choice_9 forState:UIControlStateNormal];
  // update choice image 10
  UIImage *choice_10 = [UIImage imageNamed:[self.lvl_choiceImagePathStringSavedArr objectAtIndex:10]];
  [self.button_choice_10 setBackgroundImage:choice_10 forState:UIControlStateNormal];
  
  self.button_choice_0.selected = NO;
  self.button_choice_1.selected = NO;
  self.button_choice_2.selected = NO;
  self.button_choice_3.selected = NO;
  self.button_choice_4.selected = NO;
  self.button_choice_5.selected = NO;
  self.button_choice_6.selected = NO;
  self.button_choice_7.selected = NO;
  self.button_choice_8.selected = NO;
  self.button_choice_9.selected = NO;
  self.button_choice_10.selected = NO;
}

- (int) getRandomNumber: (int) maxValue
{
  return (arc4random() % maxValue);
}

- (NSString *) getRandomReferentTypeArrayString
{
  return (self.lvl_referentTypeArr[[self getRandomNumber:LVL_IMAGES_CATEGORY__TYPE_COUNT]]);
}

- (NSString *) getRandomReferentSubTypeArrayString
{
  return (self.lvl_referentSubTypeArr[[self getRandomNumber:LVL_IMAGES_CATEGORY__SUB_TYPE_COUNT]]);
}

- (NSString *) getRandomReferentColorArrayString
{
  return (self.lvl_referentColorArr[[self getRandomNumber:LVL_IMAGES_CATEGORY__COLOR_COUNT]]);
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
  [self performSegueWithIdentifier:@"segue_levelTwoTwoToLevelScoreSheet" sender:self];
  // load score sheet automatically
  ViewControllerLevelScoreSheet *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelScoreSheet"];
  [self presentViewController:vc animated:YES completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"segue_levelTwoTwoToLevelScoreSheet"])
  {
    ViewControllerLevelScoreSheet *vc = (ViewControllerLevelScoreSheet *)segue.destinationViewController;
    vc.lvl_scoreSheet_recvUserName          = self.lvl_recvUserName;
    vc.lvl_scoreSheet_levelNumberPlayed     = LVL_PLAYED__TWO_TWO;
    vc.lvl_scoreSheet_glbRank               = 0;
    vc.lvl_scoreSheet_totalChoice           = self.lvl_totalChoiceCount;
    vc.lvl_scoreSheet_totalCorrectAnswers   = self.lvl_totalCorrectChoiceCount;
    vc.lvl_scoreSheet_incorrectAnswers      = (self.lvl_totalChoiceCount - self.lvl_totalCorrectChoiceCount);
    vc.lvl_scoreSheet_fastAnswers           = self.lvl_totalCorrectFastCount;
    vc.lvl_scoreSheet_slowAnswers           = self.lvl_totalCorrectSlowCount;
    vc.lvl_scoreSheet_okAnswers             = self.lvl_totalCorrectOkCount;
    vc.lvl_scoreSheet_Accuracy              = 0;
    vc.lvl_scoreSheet_timeLeft              = self.lvl_currMilliseconds;
    vc.lvl_scoreSheet_averageResponseTime   = (self.lvl_responseMilliSeconds / self.lvl_totalCorrectChoiceCount);
  }
}

@end
