//
//  SpxLifeVlg.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "VlgDesignConcept.h"
#import "GeneralFullScreenSlideShow.h"
@interface VlgDesignConcept()<UIScrollViewDelegate, IGeneralFullScreenSlideShow>
{
    int iR;
    int iG;
    int iB;
    GeneralFullScreenSlideShow* iArchSlideShow;
    NSMutableArray* iNameList;
}
@property(nonatomic, weak)IBOutlet UIScrollView* uiArchiSclView;
@property(nonatomic, weak)IBOutlet UIScrollView* uiInfraSclView;
@property(nonatomic, weak)IBOutlet UIScrollView* uiPubSceneSclView;
@property(nonatomic, weak)IBOutlet UIScrollView* uiSunView;
@end

@implementation VlgDesignConcept
+(id)VlgDesignConcept
{
    VlgDesignConcept *instance = [[[NSBundle mainBundle] loadNibNamed:@"VlgDesignConcept" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[VlgDesignConcept class]] )
    {
        return instance;
    }
    else
        return nil;
}

-(void)awakeFromNib
{
    self.uiArchiSclView.contentSize = CGSizeMake(226, 703);
    self.uiArchiSclView.delegate = self;
    self.uiInfraSclView.contentSize = CGSizeMake(226, 714);
    self.uiInfraSclView.delegate = self;
    self.uiPubSceneSclView.contentSize = CGSizeMake(226, 644);
    self.uiPubSceneSclView.delegate = self;
    self.uiSunView.contentSize = CGSizeMake(226, 644);
    self.uiSunView.delegate = self;
    iR = 0;
    iG = 137;
    iB = 98;
}
-(void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)changeScrollBarColorFor:(UIScrollView *)scrollView
{
    for ( UIView *view in scrollView.subviews ) {

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
-(IBAction)onRValueChanged:(id)sender
{
    UISlider* s = sender;
    iR = s.value;
}
-(IBAction)onGValueChanged:(id)sender
{
    UISlider* s = sender;
    iG = s.value;
}
-(IBAction)onBValueChanged:(id)sender
{
    UISlider* s = sender;
    iB = s.value;
}
-(void)onSlideShowDismiss:(id)theslideshow
{
    if (iArchSlideShow)
    {
        [iArchSlideShow dismissViewControllerAnimated:YES completion:nil];
        [iArchSlideShow removeFromParentViewController];
        iArchSlideShow = nil;
    }
}
-(IBAction)onSim3DClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    if (iNameList == nil)
    {
        iNameList = [[NSMutableArray alloc] initWithObjects:@"vlg_arch_01_01_simulate_01.png", @"vlg_arch_01_01_simulate_02.png",
                     @"vlg_arch_01_01_simulate_03.png", @"vlg_arch_01_01_simulate_04.png", @"vlg_arch_01_01_simulate_05.png", nil];
    }
    if (iArchSlideShow==nil)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIViewController *rootViewController = window.rootViewController;
        iArchSlideShow = [[GeneralFullScreenSlideShow alloc] initWithNibName:@"GeneralFullScreenSlideShow" bundle:nil NameList:iNameList DesList:nil];
        [iArchSlideShow setDelegate:self];
        [iArchSlideShow setupVideoPlayer:@"Comp 1_3" Index:0];
        [iArchSlideShow createCellByIndex:(int)btn.tag];
        [rootViewController presentViewController:iArchSlideShow animated:YES completion:nil];
    }
}
@end
