//
//  SpxZoneVCtrl.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/7.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "VlgVCtrl.h"
static NSString *const classVlgInterview     = @"VlgInterview";
static NSString *const classVlgDesignConcept = @"VlgDesignConcept";
static NSString *const classVlgComPath       = @"VlgComPath";
static NSString *const classVlgInterPub      = @"VlgInterPub";
static NSString *const classVlgRoomType      = @"VlgRoomType";
static NSString *const classVlgInterDeco     = @"VlgInterDeco";
static NSString *const classVlgScade         = @"VlgScade";
static NSString *const classVlgUnitSel       = @"VlgUnitSel";

@interface VlgVCtrl ()<UIScrollViewDelegate>
{
    __weak UIView* iActiveView;
}
@property(nonatomic, weak)IBOutlet UIView* uiTopBar;
@property(nonatomic, weak)IBOutlet UIView* uiMenu;
@property(nonatomic, weak)IBOutlet UIView* uiSplash;
@property(nonatomic, weak)IBOutlet UIScrollView* uiSclView;
@property(nonatomic, weak)IBOutlet UIButton* uiInterview;
@property(nonatomic, weak)IBOutlet UIButton* uiDesignConcept;
@property(nonatomic, weak)IBOutlet UIButton* uiComPath;
@property(nonatomic, weak)IBOutlet UIButton* uiInterPub;
@property(nonatomic, weak)IBOutlet UIButton* uiRoomType;
@property(nonatomic, weak)IBOutlet UIButton* uiInterDeco;
@property(nonatomic, weak)IBOutlet UIButton* uiScade;
@property(nonatomic, weak)IBOutlet UIButton* uiUnitSel;

@property(nonatomic, weak)IBOutlet UIImageView* uiTitle;

@property(nonatomic, weak)IBOutlet UIView* uiDesView;
@property(nonatomic, weak)IBOutlet UIImageView* uiTitleBigGrp;
@property(nonatomic, weak)IBOutlet UIImageView* uiTitleInternational;

@property(nonatomic, weak)IBOutlet UIButton* uiUp;
@property(nonatomic, weak)IBOutlet UIButton* uiDown;
@property(nonatomic, weak)IBOutlet UIImageView* uiBackHome;
@end

@implementation VlgVCtrl
- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.uiSclView.contentSize = CGSizeMake(905, 666*2);
    self.uiSclView.delegate = self;
    
    self.uiUp.hidden = YES;
    self.uiUp.transform = CGAffineTransformMakeRotation(M_PI);
    
    //Title
    [UIView animateKeyframesWithDuration:1.2 delay:1.2 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        self.uiSplash.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}
-(void)viewDidDisappear:(BOOL)animated
{
    iActiveView = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)openMenu
{
    if (self.uiMenu.alpha==0)
    {
        self.uiMenu.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , TOPMENU_HEIGHT);
        [UIView animateWithDuration:TOPMENU_ANIM_DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.uiMenu.frame = CGRectMake(0, TOPBAR_HEIGHT, [UIScreen mainScreen].bounds.size.width , TOPMENU_HEIGHT);
            self.uiMenu.alpha = 1;
            [self.uiMenu layoutIfNeeded];
        }
                         completion:^(BOOL a)
         {
             
         }];
    }else
    {
        self.uiMenu.frame = CGRectMake(0, TOPMENU_HEIGHT, [UIScreen mainScreen].bounds.size.width , TOPMENU_HEIGHT);
        [UIView animateWithDuration:TOPMENU_ANIM_DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.uiMenu.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , TOPMENU_HEIGHT);
            self.uiMenu.alpha = 0;
            [self.uiMenu layoutIfNeeded];
        }
                         completion:^(BOOL a)
         {
             self.uiMenu.frame = CGRectMake(0, -TOPMENU_HEIGHT, [UIScreen mainScreen].bounds.size.width , TOPMENU_HEIGHT);
         }];
    }
}

-(void)switchToViewByString:(NSString*)viewstr
{
    if (iActiveView && YES==[iActiveView isKindOfClass:NSClassFromString(viewstr)])
    {
        NSLog(@"Already has same name");
        return;
    }
    if (iActiveView)
    {
        [iActiveView removeFromSuperview];
        iActiveView = nil;
    }
    SEL selector     = NSSelectorFromString(viewstr);
    Class arrayClass = NSClassFromString (viewstr);
    UIView* instance = [arrayClass performSelector:selector];
    [self.view addSubview:instance];
    [self.view bringSubviewToFront:self.uiMenu];
    [self.view bringSubviewToFront:self.uiTopBar];
    iActiveView = instance;
}

-(void)turnOffSel
{
    self.uiInterview.selected = NO;
    self.uiDesignConcept.selected = NO;
    self.uiComPath.selected = NO;
    self.uiInterPub.selected = NO;
    self.uiRoomType.selected = NO;
    self.uiInterDeco.selected = NO;
    self.uiScade.selected = NO;
    self.uiUnitSel.selected = NO;
}

- (void)changeScrollBarColorFor:(UIScrollView *)scrollView
{
    float iR = 255;
    float iG = 255;
    float iB = 255;
    for ( UIView *view in scrollView.subviews )
    {
        if (view.tag == 0 && [view isKindOfClass:UIImageView.class])
        {
            UIImageView *imageView = (UIImageView *)view;
            imageView.backgroundColor = [UIColor colorWithRed:iR green:iG/255.0 blue:iB/255.0 alpha:1];
        }
    }
}

#pragma mark - Scroll Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeScrollBarColorFor:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y==692)
    {
        self.uiUp.hidden = NO;
        self.uiDown.hidden = YES;
    }else
    {
        self.uiUp.hidden = YES;
        self.uiDown.hidden = NO;
    }
}

- (IBAction)onCross:(id)sender
{
    self.uiDesView.hidden = YES;
}

- (IBAction)onArrowDown:(id)sender
{
    [self.uiSclView scrollRectToVisible:CGRectMake(0, 666, self.uiSclView.frame.size.width, self.uiSclView.frame.size.height) animated:YES];
    self.uiUp.hidden = NO;
    self.uiDown.hidden = YES;
}

- (IBAction)onArrowUp:(id)sender
{
    [self.uiSclView scrollRectToVisible:CGRectMake(0, 0, self.uiSclView.frame.size.width, self.uiSclView.frame.size.height) animated:YES];
    self.uiDown.hidden = NO;
    self.uiUp.hidden = YES;
}

- (IBAction)onHome:(id)sender
{
   [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)onInterview:(id)sender
{
    self.uiBackHome.hidden = NO;
    [self turnOffSel];
    self.uiInterview.selected = YES;
    [self switchToViewByString:classVlgInterview];
}

- (IBAction)onDesignConcept:(id)sender
{
    self.uiBackHome.hidden = NO;
    [self turnOffSel];
    self.uiDesignConcept.selected = YES;
    [self switchToViewByString:classVlgDesignConcept];
}

- (IBAction)onComPath:(id)sender
{
    self.uiBackHome.hidden = NO;
    [self turnOffSel];
    self.uiComPath.selected = YES;
    [self switchToViewByString:classVlgComPath];
}

- (IBAction)onInterPub:(id)sender
{
    self.uiBackHome.hidden = NO;
    [self turnOffSel];
    self.uiInterPub.selected = YES;
    [self switchToViewByString:classVlgInterPub];
}

- (IBAction)onRoomType:(id)sender
{
    [self turnOffSel];
    self.uiRoomType.selected = YES;
    [self switchToViewByString:classVlgRoomType];
}

- (IBAction)onInterDeco:(id)sender
{
    self.uiBackHome.hidden = NO;
    [self turnOffSel];
    self.uiInterDeco.selected = YES;
    [self switchToViewByString:classVlgInterDeco];
}

- (IBAction)onScade:(id)sender
{
    self.uiBackHome.hidden = NO;
    [self turnOffSel];
    self.uiScade.selected = YES;
    [self switchToViewByString:classVlgScade];
}

- (IBAction)onUnitSel:(id)sender
{
    self.uiBackHome.hidden = NO;
    [self turnOffSel];
    self.uiUnitSel.selected = YES;
    [self switchToViewByString:classVlgUnitSel];
}

@end
