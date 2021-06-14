//
//  ViewControllerCarousel.h
//  Progress
//
//  Created by Sudhir Sawarkar on 11/2/15.
//  Copyright © 2015 Catamaran Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerCarousel : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgView_carousel_background;
@property (weak, nonatomic) IBOutlet UILabel *lbl_carousel_title;

@property NSUInteger pageIndexCarousel;
@property NSString *titleTextCarousel;
@property NSString *imageFileCarousel;

@end
