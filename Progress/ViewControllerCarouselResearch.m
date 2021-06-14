//
//  ViewControllerCarouselResearch.m
//  Progress
//
//  Created by Sudhir Sawarkar on 11/17/15.
//  Copyright © 2015 Catamaran Labs. All rights reserved.
//

#import "ViewControllerCarouselResearch.h"

@interface ViewControllerCarouselResearch()

@property (weak, nonatomic) IBOutlet UIButton *button_back;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation ViewControllerCarouselResearch

- (IBAction)button_back:(id)sender // from research page back to carousel
{
  
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  // Create the data model
  _pageTitlesCarousel = @[@"Carousel1",
                          @"Carousel2",
                          @"Carousel3",
                          @"Carousel4",
                          @"Carousel5"];
  
  _pageImagesCarousel = @[@"images/carousel/Research pages_1.png",
                          @"images/carousel/Research pages_2.png",
                          @"images/carousel/Research pages_3.png",
                          @"images/carousel/Research pages_4.png",
                          @"images/carousel/Research pages_5.png"];
  
  // Create page view controller
  self.pageViewControllerCarousel = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewControllerCarouselResearch"];
  self.pageViewControllerCarousel.dataSource = self;
  
  ViewControllerCarouselResearchImage *startingViewController = [self viewControllerAtIndex:0];
  NSArray *viewControllers = @[startingViewController];
  [self.pageViewControllerCarousel setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
  
  // Change the size of page view controller
  //self.pageViewControllerCarousel.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 90);
  self.pageViewControllerCarousel.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  
  // bring carousel round buttion index in front
  /* nav control */
  //self.pageControl_carouselRoundButtonIndexDisplay.numberOfPages = self.pageTitlesCarousel.count;
  //[self.view addSubview:_pageControl_carouselRoundButtonIndexDisplay.viewForLastBaselineLayout];
  
  
  // load button images
  // UIImage *seeResearch = [UIImage imageNamed:@"images/carousel/researchButton.png"];
  // [self.button_back setBackgroundImage:seeResearch forState:UIControlStateNormal];
  
  [self addChildViewController:_pageViewControllerCarousel];
  [self.view addSubview:_pageViewControllerCarousel.view];
  [self.pageViewControllerCarousel didMoveToParentViewController:self];
  [self.view bringSubviewToFront:self.playButton];
  
  //  // add bacground images to play now and see the research views
  //  self.label_rootVC_playNow.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"images/carousel/mainButton.png"]];
  //  self.label_rootVC_seeResearch.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"images/carousel/mainButton.png"]];
  //
  //  // tap recognizer for play now and see the research label
  //  UITapGestureRecognizer *playNowLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPlayNowDetected)];
  //  playNowLabelTap.numberOfTapsRequired = 1;
  //  [self.label_rootVC_playNow setUserInteractionEnabled:YES];
  //  [self.label_rootVC_playNow addGestureRecognizer:playNowLabelTap];
  //  [self.view bringSubviewToFront:self.label_rootVC_playNow];
  //
  //  // tap recognizer for play now and see the research label
  //  UITapGestureRecognizer *seeResearchLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSeeResearchDetected)];
  //  seeResearchLabelTap.numberOfTapsRequired = 1;
  //  [self.label_rootVC_seeResearch setUserInteractionEnabled:YES];
  //  [self.label_rootVC_seeResearch addGestureRecognizer:seeResearchLabelTap];
  
  
  /* nav control */
  //[self.view bringSubviewToFront:self.pageControl_carouselRoundButtonIndexDisplay];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
  NSUInteger index = ((ViewControllerCarouselResearchImage*) viewController).pageIndexCarousel;
  
  if ((index == 0) || (index == NSNotFound)) {
    return nil;
  }
  
  index--;
  return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
  NSUInteger index = ((ViewControllerCarouselResearchImage*) viewController).pageIndexCarousel;
  
  if (index == NSNotFound) {
    return nil;
  }
  
  index++;
  if (index == [self.pageTitlesCarousel count]) {
    return nil;
  }
  return [self viewControllerAtIndex:index];
}

- (ViewControllerCarouselResearchImage *)viewControllerAtIndex:(NSUInteger)index
{
  if (([self.pageTitlesCarousel count] == 0) || (index >= [self.pageTitlesCarousel count])) {
    return nil;
  }
  
  // Create a new view controller and pass suitable data.
  ViewControllerCarouselResearchImage *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerCarouselResearchImageContent"];
  pageContentViewController.imageFileCarousel = self.pageImagesCarousel[index];
  pageContentViewController.titleTextCarousel = self.pageTitlesCarousel[index];
  pageContentViewController.pageIndexCarousel = index;
  
  
  // update carousel page control round display index
  /* nav control */
  //self.pageControl_carouselRoundButtonIndexDisplay.currentPage = index;
  //self.pageControl_carouselRoundButtonIndexDisplay.currentPage = [self.pageTitlesCarousel count];
  
  return pageContentViewController;
}

/* Creates 40 px nav bar at bottom of carousel */
/////////////////////
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
  return [self.pageTitlesCarousel count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
  return 0;
}
//////////////////////

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
