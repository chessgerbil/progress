//
//  ViewControllerRoot.m
//  Progress
//
//  Created by Sudhir Sawarkar on 11/2/15.
//  Copyright © 2015 Catamaran Labs. All rights reserved.
//

#import "ViewControllerRoot.h"
#import "ViewControllerLevelHome.h"

@interface ViewControllerRoot ()
@property (weak, nonatomic) IBOutlet UIButton *btn_rootVC_getStarted;
@property (weak, nonatomic) IBOutlet UIButton *btn_rootVC_seeResearch;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl_carouselRoundButtonIndexDisplay;
//@property (weak, nonatomic) IBOutlet UILabel *label_rootVC_playNow;
//@property (weak, nonatomic) IBOutlet UILabel *label_rootVC_seeResearch;

@end

@implementation ViewControllerRoot

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return interfaceOrientation == UIInterfaceOrientationPortrait;
}

//-(void)tapPlayNowDetected
//{
//  NSLog(@"TAP detected");
//  ViewControllerLevelHome *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLevelHome"];
//  [self presentViewController:vc animated:YES completion:nil];
//}
//
//- (void) tapSeeResearchDetected
//{
//  
//}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  // Create the data model
  _pageTitlesCarousel = @[@"Carousel0",
                          @"Carousel1",
                          @"Carousel2",
                          @"Carousel3",
                          @"Carousel4"];
    
  _pageImagesCarousel = @[@"images/carousel/iPad 2x No Button_Carousel I.png",
                          @"images/carousel/iPad 2x No Button_Carousel II.png",
                          @"images/carousel/iPad 2x No Button_Carousel III.png",
                          @"images/carousel/iPad 2x No Button_Carousel IV.png",
                          @"images/carousel/iPad 2x No Button_Carousel V.png"];
    
  // Create page view controller
  self.pageViewControllerCarousel = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewControllerCarousel"];
  self.pageViewControllerCarousel.dataSource = self;
    
  ViewControllerCarousel *startingViewController = [self viewControllerAtIndex:0];
  NSArray *viewControllers = @[startingViewController];
  [self.pageViewControllerCarousel setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
  // Change the size of page view controller
  //self.pageViewControllerCarousel.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 90);
  self.pageViewControllerCarousel.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  
  // bring carousel round buttion index in front
  /* nav control */
  self.pageControl_carouselRoundButtonIndexDisplay.numberOfPages = self.pageTitlesCarousel.count;
  //[self.view addSubview:_pageControl_carouselRoundButtonIndexDisplay.viewForLastBaselineLayout];

  
  // load button images
  //UIImage *playNow = [UIImage imageNamed:@"images/carousel/mainButton.png"];
  //[self.btn_rootVC_getStarted setBackgroundImage:playNow forState:UIControlStateNormal];
  
  //UIImage *seeResearch = [UIImage imageNamed:@"images/carousel/researchButton.png"];
  //[self.btn_rootVC_seeResearch setBackgroundImage:seeResearch forState:UIControlStateNormal];
  
  [self addChildViewController:_pageViewControllerCarousel];
  [self.view addSubview:_pageViewControllerCarousel.view];
  [self.pageViewControllerCarousel didMoveToParentViewController:self];
  [self.view bringSubviewToFront:self.btn_rootVC_getStarted];
  [self.view bringSubviewToFront:self.btn_rootVC_seeResearch];
  
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
    NSUInteger index = ((ViewControllerCarousel*) viewController).pageIndexCarousel;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ViewControllerCarousel*) viewController).pageIndexCarousel;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitlesCarousel count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (ViewControllerCarousel *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitlesCarousel count] == 0) || (index >= [self.pageTitlesCarousel count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    ViewControllerCarousel *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerCarouselPageContent"];
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

- (IBAction)btn_rootVC_getStarted:(id)sender {
}

- (IBAction)btn_rootVC_seeResearch:(id)sender {
}
@end
