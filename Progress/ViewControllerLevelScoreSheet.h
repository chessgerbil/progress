//
//  ViewControllerLevelScoreSheet.h
//  Progress
//
//  Created by Sudhir Sawarkar on 11/7/15.
//  Copyright © 2015 Catamaran Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerLevelScoreSheet : UIViewController

@property (weak, nonatomic) NSString * lvl_scoreSheet_recvUserName;
@property(nonatomic) int               lvl_scoreSheet_levelNumberPlayed;
@property(nonatomic) int               lvl_scoreSheet_glbRank;
@property(nonatomic) int               lvl_scoreSheet_totalChoice;
@property(nonatomic) int               lvl_scoreSheet_totalCorrectAnswers;
@property(nonatomic) int               lvl_scoreSheet_incorrectAnswers;
@property(nonatomic) int               lvl_scoreSheet_fastAnswers;
@property(nonatomic) int               lvl_scoreSheet_slowAnswers;
@property(nonatomic) int               lvl_scoreSheet_okAnswers;
@property(nonatomic) int               lvl_scoreSheet_Accuracy;
@property(nonatomic) int               lvl_scoreSheet_timeLeft;
@property(nonatomic) int               lvl_scoreSheet_averageResponseTime;

@end
