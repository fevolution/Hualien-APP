//
//  SpxLifeVlg.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//
#import "GeneralScaleZoomVCtrl.h"
#import "VlgRoomType.h"
#import "GeneralFullScreenSlideShow.h"
#import "HLIntroScnCell.h"

#import "VlgRoomCell.h"
#define MOVE_DURATION 0.5
#define TOPBAR_BOTTOM_Y 160
@interface VlgRoomType()<IHLIntroScnCellDelegate, IGeneralFullScreenSlideShow, IVlgRoomCell>
{
    NSMutableArray* iTLRoomLNLLogoList;
    NSMutableArray* iTLRoomLogoList;
    NSMutableArray* iCellList;
    NSMutableArray* iTopBtnList;
    NSMutableArray* iSubBtnList;
    NSMutableArray* iCellImagePairList;

}
@property(nonatomic, weak)IBOutlet UIButton* uiTop01;
@property(nonatomic, weak)IBOutlet UIButton* uiTop02;
@property(nonatomic, weak)IBOutlet UIButton* uiSub01_01;
@property(nonatomic, weak)IBOutlet UIButton* uiSub01_02;
@property(nonatomic, weak)IBOutlet UIButton* uiSub01_03;
@property(nonatomic, weak)IBOutlet UIButton* uiSub01_04;
@property(nonatomic, weak)IBOutlet UIButton* uiSub02_01;
@property(nonatomic, weak)IBOutlet UIButton* uiSub02_02;
@property(nonatomic, weak)IBOutlet UIButton* uiSub02_03;
@property(nonatomic, weak)IBOutlet UIButton* uiSub02_04;
@property(nonatomic, weak)IBOutlet UIView* uiHouseHouseMenu;
@property(nonatomic, weak)IBOutlet UIView* uiOneTierMenu;
@property(nonatomic, weak)IBOutlet UIView* uiTopMenuGroup;
@property(nonatomic, weak)IBOutlet UIView* uiSliderContainer;


@property(nonatomic, weak)IBOutlet UIImageView* uiLogoRoom1LnL;
@property(nonatomic, weak)IBOutlet UIImageView* uiLogoRoom2LnL;
@property(nonatomic, weak)IBOutlet UIImageView* uiLogoRoom3LnL;
@property(nonatomic, weak)IBOutlet UIImageView* uiLogoRoom4LnL;

@property(nonatomic, weak)IBOutlet UIImageView* uiLogo1Room;
@property(nonatomic, weak)IBOutlet UIImageView* uiLogo2Room;
@property(nonatomic, weak)IBOutlet UIImageView* uiLogo3Room;
@property(nonatomic, weak)IBOutlet UIImageView* uiLogoSRoom;

@property(nonatomic, weak)IBOutlet UIImageView* uiLogo;
@end

//35 1236 Gap 400.333
@implementation VlgRoomType
+(id)VlgRoomType
{
    VlgRoomType *instance = [[[NSBundle mainBundle] loadNibNamed:@"VlgRoomType" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[VlgRoomType class]] )
    {
        return instance;
    }
    else
        return nil;
}

-(void)awakeFromNib
{
    iTLRoomLNLLogoList = [[NSMutableArray alloc] initWithObjects:self.uiLogoRoom4LnL, self.uiLogoRoom3LnL, self.uiLogoRoom2LnL, self.uiLogoRoom1LnL, nil];
    [self hideAllRoomLnL];
    
    iTLRoomLogoList = [[NSMutableArray alloc] initWithObjects:self.uiLogo3Room, self.uiLogo2Room, self.uiLogo1Room, self.uiLogoSRoom, nil];
    [self hideAllRoom];
    
    iTopBtnList = [[NSMutableArray alloc] initWithObjects:self.uiTop01, self.uiTop02, nil];
    iSubBtnList = [[NSMutableArray alloc] initWithObjects:self.uiSub01_01, self.uiSub01_02, self.uiSub01_03, self.uiSub01_04,
                   self.uiSub02_01, self.uiSub02_02, self.uiSub02_03, self.uiSub02_04, nil];
    [self hideHouseInHouseMenu];
    [self hideOneTierMenu];



    //Image Pair for Cell
    iCellImagePairList = [[NSMutableArray alloc] initWithObjects:
                          @"vlg_arch_01_04_houseroom_bigimage_01_01.png", @"vlg_arch_01_04_houseroom_bigimage_01_02.png",
                          @"vlg_arch_01_04_houseroom_bigimage_02_01.png", @"vlg_arch_01_04_houseroom_bigimage_02_02.png",
                          @"vlg_arch_01_04_houseroom_bigimage_03_01.png", @"vlg_arch_01_04_houseroom_bigimage_03_02.png",
                          @"vlg_arch_01_04_houseroom_bigimage_04_01.png", @"vlg_arch_01_04_houseroom_bigimage_04_02.png",
                          @"vlg_arch_01_04_houseroom_bigimage_05_01.png", @"vlg_arch_01_04_houseroom_bigimage_05_02.png",
                          @"vlg_arch_01_04_houseroom_bigimage_06_01.png", @"vlg_arch_01_04_houseroom_bigimage_06_02.png",
                          @"vlg_arch_01_04_houseroom_bigimage_07_01.png", @"vlg_arch_01_04_houseroom_bigimage_07_02.png",
                          @"vlg_arch_01_04_houseroom_bigimage_08_01.png", @"vlg_arch_01_04_houseroom_bigimage_08_02.png",
                          nil];
    [self onBtnClick:self.uiSub01_01];
}
-(void)dealloc
{
    NSLog(@"%s", __func__);
}
-(void)showHouseInHouseMenu
{
    [self bringSubviewToFront:self.uiHouseHouseMenu];
    [self bringSubviewToFront:self.uiTopMenuGroup];
    if (self.uiHouseHouseMenu.frame.origin.y==150)
    {
        [UIView animateWithDuration:MOVE_DURATION animations:^{
            self.uiHouseHouseMenu.alpha = 0;
            self.uiHouseHouseMenu.frame = CGRectMake(self.uiHouseHouseMenu.frame.origin.x, -20,
                                                     self.uiHouseHouseMenu.frame.size.width, self.uiHouseHouseMenu.frame.size.height);
        }];
    }else
    {
        [UIView animateWithDuration:MOVE_DURATION animations:^{
            self.uiHouseHouseMenu.alpha = 1;
            self.uiHouseHouseMenu.frame = CGRectMake(self.uiHouseHouseMenu.frame.origin.x, 150,
                                                 self.uiHouseHouseMenu.frame.size.width, self.uiHouseHouseMenu.frame.size.height);
        }];
    }
}
-(void)showOneTierMenu
{
    [self bringSubviewToFront:self.uiOneTierMenu];
    [self bringSubviewToFront:self.uiTopMenuGroup];
    if (self.uiOneTierMenu.frame.origin.y==150)
    {
        [UIView animateWithDuration:MOVE_DURATION animations:^{
            self.uiOneTierMenu.alpha = 0;
            self.uiOneTierMenu.frame = CGRectMake(self.uiOneTierMenu.frame.origin.x, -20,
                                                     self.uiOneTierMenu.frame.size.width, self.uiOneTierMenu.frame.size.height);
        }];
    }else
    {
        [UIView animateWithDuration:MOVE_DURATION animations:^{
            self.uiOneTierMenu.alpha = 1;
            self.uiOneTierMenu.frame = CGRectMake(self.uiOneTierMenu.frame.origin.x, 150,
                                              self.uiOneTierMenu.frame.size.width, self.uiOneTierMenu.frame.size.height);
        }];
    }
}
-(void)hideHouseInHouseMenu
{
    [UIView animateWithDuration:MOVE_DURATION animations:^{
        self.uiHouseHouseMenu.alpha = 0;
        self.uiHouseHouseMenu.frame = CGRectMake(self.uiHouseHouseMenu.frame.origin.x, -20,
                                                 self.uiHouseHouseMenu.frame.size.width, self.uiHouseHouseMenu.frame.size.height);
    }];
}
-(void)hideOneTierMenu
{
    [UIView animateWithDuration:MOVE_DURATION animations:^{
        self.uiOneTierMenu.alpha = 0;
        self.uiOneTierMenu.frame = CGRectMake(self.uiOneTierMenu.frame.origin.x, -20,
                                              self.uiOneTierMenu.frame.size.width, self.uiOneTierMenu.frame.size.height);
    }];
}
-(void)hideAllRoomLnL
{
    self.uiLogoRoom1LnL.hidden = YES;
    self.uiLogoRoom2LnL.hidden = YES;
    self.uiLogoRoom3LnL.hidden = YES;
    self.uiLogoRoom4LnL.hidden = YES;
}
-(void)hideAllRoom
{
    self.uiLogo1Room.hidden = YES;
    self.uiLogo2Room.hidden = YES;
    self.uiLogo3Room.hidden = YES;
    self.uiLogoSRoom.hidden = YES;
}
-(void)showRoomLnLByIndex:(int)index
{
    UIImageView* img = [iTLRoomLNLLogoList objectAtIndex:index];
    if (img)
    {
        img.hidden = NO;
    }
}
-(void)showRoomByIndex:(int)index
{
    UIImageView* img = [iTLRoomLogoList objectAtIndex:index];
    if (img)
    {
        img.hidden = NO;
    }
}
-(IBAction)onHouseInHouseClick:(id)sender
{
    self.uiTop02.selected = NO;
    if (self.uiHouseHouseMenu.frame.origin.y == TOPBAR_BOTTOM_Y)
    {
        [self hideHouseInHouseMenu];
        self.uiTop01.selected = NO;
    }else
    {
        [self hideOneTierMenu];
        [self showHouseInHouseMenu];
        self.uiTop01.selected = YES;
    }
}
-(IBAction)onOneTierClick:(id)sender
{
    self.uiTop01.selected = NO;
    if (self.uiOneTierMenu.frame.origin.y == TOPBAR_BOTTOM_Y)
    {
        [self hideOneTierMenu];
        self.uiTop02.selected = NO;
    }else
    {
        [self hideHouseInHouseMenu];
        [self showOneTierMenu];
        self.uiTop02.selected = YES;
    }
}
-(void)turnoffBtnSelected
{
    for (int i = 0; i < [iSubBtnList count]; i++)
    {
        UIButton* btn  = [iSubBtnList objectAtIndex:i];
        btn.selected = NO;
    }
}
-(IBAction)onBtnClick:(id)sender
{
    if ([self.uiSliderContainer.subviews count] && [self.uiSliderContainer.subviews objectAtIndex:0])
    {
        [[self.uiSliderContainer.subviews objectAtIndex:0] removeFromSuperview];
    }

    
    [self turnoffBtnSelected];
    UIButton* btn = (UIButton*)sender;
    btn.selected = YES;
    int tag = (int)btn.tag;
    
    //Show Hide Left Bottom Logo
    [self hideAllRoomLnL];
    [self hideAllRoom];
    if (tag < 4)
    {
        [self showRoomLnLByIndex:tag];
    }else if (tag >=4)
    {
        [self showRoomByIndex:tag-4];
    }
    
    VlgRoomCell* cell = [VlgRoomCell VlgRoomCell];
    [cell setFstImg:[iCellImagePairList objectAtIndex:tag*2] SecImg:[iCellImagePairList objectAtIndex:tag*2+1]];
    cell.frame = CGRectMake(0, 0, 974, 536);
    cell.delegate = self;
    [self.uiSliderContainer addSubview:cell];
    
    [self onPlanViewHide];
}
-(void)onSlideShowDismiss:(id)theslideshow
{
    [theslideshow removeFromSuperview];
}
-(void)ScnCellClickToFullScreen:(UIImage*)image
{
    UIWindow* lastobj = [[[UIApplication sharedApplication] windows] lastObject];
    UIViewController* rootVC = lastobj.rootViewController;
    GeneralScaleZoomVCtrl* singleImgCtrl = [[GeneralScaleZoomVCtrl alloc] initWithNibName:@"GeneralScaleZoomVCtrl" bundle:nil Image:image];
    [rootVC presentViewController:singleImgCtrl animated:YES completion:nil];
}

#pragma mark- Cell
-(void)onPlanViewShow
{
    self.uiLogo.hidden = YES;
}
-(void)onPlanViewHide
{
    self.uiLogo.hidden = NO;
}
-(void)onPlanViewClick:(UIImage*)image
{
    UIWindow* lastobj = [[[UIApplication sharedApplication] windows] lastObject];
    UIViewController* rootVC = lastobj.rootViewController;
    GeneralScaleZoomVCtrl* singleImgCtrl = [[GeneralScaleZoomVCtrl alloc] initWithNibName:@"GeneralScaleZoomVCtrl" bundle:nil Image:image];
    [singleImgCtrl turnGreenCross];
    [rootVC presentViewController:singleImgCtrl animated:YES completion:nil];
}
@end
