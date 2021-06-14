//
//  ViewControllerCarousel.m
//  Progress
//
//  Created by Sudhir Sawarkar on 11/2/15.
//  Copyright © 2015 Catamaran Labs. All rights reserved.
//

#import "ViewControllerCarousel.h"

@interface ViewControllerCarousel ()

@end

@implementation ViewControllerCarousel

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imgView_carousel_background.image = [UIImage imageNamed:self.imageFileCarousel];
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
