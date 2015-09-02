//
//  SpxZoneVCtrl.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/7.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "VlgFtrVCtrl.h"
static NSString *const classVlgSmart   = @"VlgSmart";
static NSString *const classVlgService = @"VlgService";

@interface VlgFtrVCtrl ()<UIScrollViewDelegate>
{
    __weak UIView* iActiveView;
}
@property(nonatomic, weak)IBOutlet UIView* uiTopBar;
@property(nonatomic, weak)IBOutlet UIView* uiMenu;
@property(nonatomic, weak)IBOutlet UIView* uiSplash;
@property(nonatomic, weak)IBOutlet UIView* uiSplash2;
@property(nonatomic, weak)IBOutlet UIButton* uiSmart;
@property(nonatomic, weak)IBOutlet UIButton* uiVlgService;
@property(nonatomic, weak)IBOutlet UIImageView* uiTitle;

@property(nonatomic, weak)IBOutlet UIView* uiDesView;
@property(nonatomic, weak)IBOutlet UIImageView* uiTitleBigGrp;
@property(nonatomic, weak)IBOutlet UIImageView* uiTitleInternational;

@property(nonatomic, weak)IBOutlet UIImageView* uiBackHome;
@end

@implementation VlgFtrVCtrl
- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Title
    [UIView animateKeyframesWithDuration:1.2 delay:1.2 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        self.uiSplash.alpha = 0;
    } completion:^(BOOL finished) {
    
    }];
    
    [UIView animateKeyframesWithDuration:1.2 delay:1.8 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        self.uiSplash2.alpha = 1;
    } completion:^(BOOL finished) {
        /*
        [UIView animateKeyframesWithDuration:1.5 delay:2.4 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            self.uiSplash2.alpha = 0;
        } completion:^(BOOL finished) {
            //self.uiSplash2.hidden = YES;//
        }];
        */
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
    self.uiVlgService.selected = NO;
    self.uiSmart.selected = NO;
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

- (IBAction)onDismissSplash2:(id)sender
{
    self.uiSplash2.hidden = YES;
}

- (IBAction)onHome:(id)sender
{
    self.uiBackHome.hidden = NO;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)onSmart:(id)sender
{
    self.uiBackHome.hidden = NO;
    [self turnOffSel];
    self.uiSmart.selected = YES;
    [self switchToViewByString:classVlgSmart];
}

- (IBAction)onVlgService:(id)sender
{
    [self turnOffSel];
    self.uiVlgService.selected = YES;
    [self switchToViewByString:classVlgService];
}
@end
