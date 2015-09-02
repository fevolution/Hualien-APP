//
//  FunLifeVCtrl.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/3/30.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "FunLifeVCtrl.h"
#import "HLIntroView.h"
#import "HLTourGuide.h"

static NSString *const classHLIntroView = @"HLIntroView";
static NSString *const classHLTourGuide = @"HLTourGuide";

@interface FunLifeVCtrl ()
{
    __weak UIView* iActiveView;
    NSMutableArray* iPreViewList;
}
@property(nonatomic, weak)IBOutlet UIView* uiTopBar;
@property(nonatomic, weak)IBOutlet UIView* uiMenu;
@property(nonatomic, weak)IBOutlet UIView* uiSplash;
@property(nonatomic, weak)IBOutlet UIButton* uiIntro;
@property(nonatomic, weak)IBOutlet UIButton* uiTourGuide;
@property(nonatomic, weak)IBOutlet UIButton* uiPrev;
@property(nonatomic, weak)IBOutlet UIImageView* uiBackHome;
@end

@implementation FunLifeVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    iPreViewList = [[NSMutableArray alloc] init];
    
    //Title
    [UIView animateKeyframesWithDuration:1.2 delay:1.8 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        self.uiSplash.alpha = 0;
    } completion:^(BOOL finished) {
    }];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
    if ([viewstr isEqualToString:@"HLIntroView"])
    {
        HLIntroView* instance = [HLIntroView HLIntroView];
        [self.view addSubview:instance];
        iActiveView = instance;
        //[iPreViewList addObject:iActiveView];
    }
    else if ([viewstr isEqualToString:@"HLTourGuide"])
    {
        HLTourGuide* instance = [HLTourGuide HLTourGuide];
        [self.view addSubview:instance];
        iActiveView = instance;
        //[iPreViewList addObject:iActiveView];
    }
    /*
    SEL selector     = NSSelectorFromString(viewstr);
    Class arrayClass = NSClassFromString (viewstr);
    UIView* instance = [arrayClass performSelector:selector];
    [self.view addSubview:instance];
    */
    
    [self.view bringSubviewToFront:self.uiMenu];
    [self.view bringSubviewToFront:self.uiTopBar];
    /*
    iActiveView = instance;
    */
}

- (IBAction)onPrev:(id)sender
{
    if ([iPreViewList count]==0)
    {
        [self onHome:nil];
    }else
    {
        UIView* v = [iPreViewList lastObject];
        [v removeFromSuperview];
        [iPreViewList removeLastObject];
        if ([iPreViewList count]==0)
        {
            [self onHome:nil];
        }
    }
}
- (IBAction)onHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)onTitle:(id)sender
{
    [self openMenu];
}

- (IBAction)onIntro:(id)sender
{
    self.uiBackHome.hidden = NO;
    self.uiIntro.selected = YES;
    self.uiTourGuide.selected = NO;
    [self switchToViewByString:classHLIntroView];
}

- (IBAction)onTourGuide:(id)sender
{
    self.uiBackHome.hidden = NO;
    self.uiTourGuide.selected = YES;
    self.uiIntro.selected = NO;
    [self switchToViewByString:classHLTourGuide];
}
@end
