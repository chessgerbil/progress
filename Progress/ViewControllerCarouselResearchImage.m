//
//  ViewControllerCarouselResearchImage.m
//  Progress
//
//  Created by Sudhir Sawarkar on 11/17/15.
//  Copyright © 2015 Catamaran Labs. All rights reserved.
//

#import "ViewControllerCarouselResearchImage.h"

@implementation ViewControllerCarouselResearchImage


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.imgView_carousel_research_background.image = [UIImage imageNamed:self.imageFileCarousel];
  //self.lbl_carousel_title.text = self.titleTextCarousel;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
