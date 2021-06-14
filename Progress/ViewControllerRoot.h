//
//  ViewControllerRoot.h
//  Progress
//
//  Created by Sudhir Sawarkar on 11/2/15.
//  Copyright © 2015 Catamaran Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerCarousel.h"

@interface ViewControllerRoot : UIViewController <UIPageViewControllerDataSource>

- (IBAction)btn_rootVC_getStarted:(id)sender;  // go th home screen
- (IBAction)btn_rootVC_seeResearch:(id)sender; // research page

@property (strong, nonatomic) UIPageViewController *pageViewControllerCarousel;
@property (strong, nonatomic) NSArray *pageTitlesCarousel;
@property (strong, nonatomic) NSArray *pageImagesCarousel;

@end
