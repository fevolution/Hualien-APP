//
//  SpxLifeVlg.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "VlgInterPub.h"
#import "GeneralFullScreenSlideShow.h"
@interface VlgInterPub()<UIScrollViewDelegate, IGeneralFullScreenSlideShow>
{
    NSMutableArray* iCellList;
    int iR;
    int iG;
    int iB;
    GeneralFullScreenSlideShow* iNorthSlideShow;
    GeneralFullScreenSlideShow* iSouthSlideShow;
    GeneralFullScreenSlideShow* iWestSlideShow;
    NSMutableArray* iNameList;
}
@property(nonatomic, weak)IBOutlet UIScrollView* uiNorthSclView;
@property(nonatomic, weak)IBOutlet UIScrollView* uiSouthSclView;
@property(nonatomic, weak)IBOutlet UIScrollView* uiWestSclView;
@end

//35 1236 Gap 400.333
@implementation VlgInterPub
+(id)VlgInterPub
{
    VlgInterPub *instance = [[[NSBundle mainBundle] loadNibNamed:@"VlgInterPub" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[VlgInterPub class]] )
    {
        return instance;
    }
    else
        return nil;
}

-(void)awakeFromNib
{
    self.uiNorthSclView.contentSize = CGSizeMake(294, 1710);
    self.uiNorthSclView.delegate = self;
    self.uiSouthSclView.contentSize = CGSizeMake(294, 676);
    self.uiSouthSclView.delegate = self;
    self.uiWestSclView.contentSize = CGSizeMake(294, 600);
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
-(void)onSlideShowDismiss:(id)theslideshow
{
    if (iNorthSlideShow)
    {
        [iNorthSlideShow dismissViewControllerAnimated:YES completion:nil];
        iNorthSlideShow = nil;
    }
    if (iSouthSlideShow)
    {
        [iSouthSlideShow dismissViewControllerAnimated:YES completion:nil];
        iSouthSlideShow = nil;
    }
    if (iWestSlideShow)
    {
        [iWestSlideShow dismissViewControllerAnimated:YES completion:nil];
        iWestSlideShow = nil;
    }
}
-(IBAction)onNorthClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    if (iNorthSlideShow==nil)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIViewController *rootViewController = window.rootViewController;

        NSMutableArray* namelist = [[NSMutableArray alloc] initWithObjects:@"vlg_01_03_north_01.png", @"vlg_01_03_north_04.png", @"vlg_01_03_north_06.png", @"vlg_01_03_north_02.png", @"vlg_01_03_north_08.png",  @"vlg_01_03_north_03.png", @"vlg_01_03_north_05.png",  @"vlg_01_03_north_07.png", @"vlg_01_03_north_09.png", @"vlg_01_03_north_10.png", nil];
        NSMutableArray* deslist = [[NSMutableArray alloc] initWithObjects:@"vlg_01_03_north_01_des.png", @"vlg_01_03_north_04_des.png", @"vlg_01_03_north_06_des.png", @"vlg_01_03_north_02_des.png", @"vlg_01_03_north_08_des.png",  @"vlg_01_03_north_03_des.png", @"vlg_01_03_north_05_des.png",  @"vlg_01_03_north_07_des.png", @"vlg_01_03_north_09_des.png", @"vlg_01_03_north_10_des.png", nil];

        iNorthSlideShow = [[GeneralFullScreenSlideShow alloc] initWithNibName:@"GeneralFullScreenSlideShow" bundle:nil NameList:namelist DesList:deslist];
        [iNorthSlideShow setDelegate:self];
        [iNorthSlideShow createCellByIndex:(int)btn.tag];
        [rootViewController presentViewController:iNorthSlideShow animated:YES completion:nil];
    }

}
-(IBAction)onSouthClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    if (iSouthSlideShow==nil)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIViewController *rootViewController = window.rootViewController;

        NSMutableArray* namelist = [[NSMutableArray alloc] initWithObjects:@"vlg_01_03_south_01.png", @"vlg_01_03_south_02.png", @"vlg_01_03_south_03.png", @"vlg_01_03_south_04.png", nil];
        NSMutableArray* deslist = [[NSMutableArray alloc] initWithObjects:@"vlg_01_03_south_01_des.png", @"vlg_01_03_south_02_des.png", @"vlg_01_03_south_03_des.png", @"vlg_01_03_south_04_des.png", nil];
        iSouthSlideShow = [[GeneralFullScreenSlideShow alloc] initWithNibName:@"GeneralFullScreenSlideShow" bundle:nil NameList:namelist DesList:deslist];
        [iSouthSlideShow setDelegate:self];
        [iSouthSlideShow createCellByIndex:(int)btn.tag];

        [rootViewController presentViewController:iSouthSlideShow animated:YES completion:nil];
    }
}
-(IBAction)onWestClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    if (iWestSlideShow==nil)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIViewController *rootViewController = window.rootViewController;

        iWestSlideShow = [[GeneralFullScreenSlideShow alloc] initWithNibName:@"GeneralFullScreenSlideShow" bundle:nil NameList:[[NSMutableArray alloc] initWithObjects:@"vlg_01_03_west_01.png", nil] DesList:[[NSMutableArray alloc] initWithObjects:@"vlg_01_03_west_des.png", nil]];
        [iWestSlideShow setDelegate:self];
        [iWestSlideShow createCellByIndex:(int)btn.tag];
        [iWestSlideShow disableAllArrow];
        [rootViewController presentViewController:iWestSlideShow animated:YES completion:nil];
    }
}
@end
