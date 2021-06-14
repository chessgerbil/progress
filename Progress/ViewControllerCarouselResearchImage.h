//
//  ViewControllerCarouselResearchImage.h
//  Progress
//
//  Created by Sudhir Sawarkar on 11/17/15.
//  Copyright © 2015 Catamaran Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerCarouselResearchImage : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgView_carousel_research_background;

@property NSUInteger pageIndexCarousel;
@property NSString *titleTextCarousel;
@property NSString *imageFileCarousel;

@end
