//
//  ViewControllerCarouselResearch.h
//  Progress
//
//  Created by Sudhir Sawarkar on 11/17/15.
//  Copyright © 2015 Catamaran Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerCarouselResearchImage.h"

@interface ViewControllerCarouselResearch : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewControllerCarousel;
@property (strong, nonatomic) NSArray *pageTitlesCarousel;
@property (strong, nonatomic) NSArray *pageImagesCarousel;

@end
