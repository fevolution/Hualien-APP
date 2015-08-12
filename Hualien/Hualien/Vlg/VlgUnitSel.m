//
//  SpxLifeVlg.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//
#import "GeneralSingleSlideShow.h"
#import "GeneralScaleZoomVCtrl.h"
#import "VlgUnitSel.h"
#import "GeneralFullScreenSlideShow.h"
#import "HLIntroScnCell.h"
#define MOVE_DURATION 0.5
#define TOPBAR_BOTTOM_Y 110
@interface VlgUnitSel()<IGeneralFullScreenSlideShow, IGeneralSingleSlideShow>
{
    NSMutableArray* iCellList;
    NSMutableArray* iTopBtnList;
    NSMutableArray* iSubBtnList;
    NSMutableArray* iCellImagePairList;
    GeneralSingleSlideShow* iSingleSlideShow;
    BOOL iMenuMoving;
}
@property(nonatomic, weak)IBOutlet UIButton* uiMtn;
@property(nonatomic, weak)IBOutlet UIButton* uiLst;

//RoomType
@property(nonatomic, weak)IBOutlet UIView* uiRoomTypeDropDown;
@property(nonatomic, weak)IBOutlet UIView* uiRoomTypeBtnView;
@property(nonatomic, weak)IBOutlet UIButton* uiRoomTypeArrowDw;
@property(nonatomic, weak)IBOutlet UIButton* uiRoomTypeArrowUp;

@property(nonatomic, weak)IBOutlet UIView* uiMtnView;
@property(nonatomic, weak)IBOutlet UIView* uiListView;
@end

//35 1236 Gap 400.333
@implementation VlgUnitSel
+(id)VlgUnitSel
{
    VlgUnitSel *instance = [[[NSBundle mainBundle] loadNibNamed:@"VlgUnitSel" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[VlgUnitSel class]] )
    {
        return instance;
    }
    else
        return nil;
}
-(void)onSlideShowDismiss:(id)theslideshow
{
    [iSingleSlideShow dismissViewControllerAnimated:NO completion:nil];
    [iSingleSlideShow removeFromParentViewController];
    iSingleSlideShow = nil;
}
-(void)onSingleSlideShowClose
{
    [iSingleSlideShow dismissViewControllerAnimated:NO completion:nil];
    [iSingleSlideShow removeFromParentViewController];
    iSingleSlideShow = nil;
}
-(void)awakeFromNib
{
    self.uiListView.hidden = YES;
    self.uiMtnView.hidden = YES;
    
    iMenuMoving = NO;
    
    //RoomType Mask Layer
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0,176, 280));
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    [shapeLayer setPath:path];
    [shapeLayer setFrame:CGRectMake(0, 0,176, 280)];
    [[self.uiRoomTypeDropDown layer] setMask:shapeLayer];
    CGPathRelease(path);
}
-(void)dealloc
{
    NSLog(@"%s", __func__);
}
-(IBAction)onMtnClick:(id)sender
{
    self.uiMtn.selected = YES;
    self.uiLst.selected = NO;
    self.uiMtnView.hidden = NO;
    self.uiListView.hidden = YES;
}
-(IBAction)onLstClick:(id)sender
{
    self.uiLst.selected = YES;
    self.uiMtn.selected = NO;
    self.uiMtnView.hidden = YES;
    self.uiListView.hidden = NO;
}
-(IBAction)onSkyViewClick:(id)sender
{
    UIImage* image = [UIImage imageNamed:@"vlg_sel_tmp_panarama.png"];
    UIWindow* lastobj = [[[UIApplication sharedApplication] windows] lastObject];
    UIViewController* rootVC = lastobj.rootViewController;
    GeneralScaleZoomVCtrl* singleImgCtrl = [[GeneralScaleZoomVCtrl alloc] initWithNibName:@"GeneralScaleZoomVCtrl" bundle:nil Image:image];
    [singleImgCtrl setZoomEnable:NO];
    [rootVC presentViewController:singleImgCtrl animated:YES completion:nil];
    [singleImgCtrl turnWhiteCross];
}
-(IBAction)onPlanViewClick:(id)sender
{
    UIImage* image = [UIImage imageNamed:@"vlg_04_ref_floor.png"];
    UIWindow* lastobj = [[[UIApplication sharedApplication] windows] lastObject];
    UIViewController* rootVC = lastobj.rootViewController;
    GeneralScaleZoomVCtrl* singleImgCtrl = [[GeneralScaleZoomVCtrl alloc] initWithNibName:@"GeneralScaleZoomVCtrl" bundle:nil Image:image];
    [rootVC presentViewController:singleImgCtrl animated:YES completion:nil];
    [singleImgCtrl turnGreenCross];
}

//RoomType DropDown
-(IBAction)onRoomTypeDownBtn:(id)sender
{
    if (iMenuMoving==NO)
    {
        self.uiRoomTypeArrowDw.hidden = YES;
        self.uiRoomTypeArrowUp.hidden = NO;
        iMenuMoving = YES;
        [UIView animateWithDuration:1 animations:^{
            self.uiRoomTypeBtnView.frame = CGRectMake(0, 40, self.uiRoomTypeBtnView.frame.size.width, self.uiRoomTypeBtnView.frame.size.height);
        } completion:^(BOOL finished) {
            
            iMenuMoving = NO;
            NSLog(@"com :%d", iMenuMoving);
        }];
        self.uiMtn.hidden = YES;
        self.uiLst.hidden = YES;
    }
}
-(IBAction)onRoomTypeUpBtn:(id)sender
{
    if (iMenuMoving==NO)
    {
        self.uiRoomTypeArrowDw.hidden = NO;
        self.uiRoomTypeArrowUp.hidden = YES;
        iMenuMoving = YES;
        [UIView animateWithDuration:1 animations:^{
             self.uiRoomTypeBtnView.frame = CGRectMake(0, -280, self.uiRoomTypeBtnView.frame.size.width, self.uiRoomTypeBtnView.frame.size.height);
        } completion:^(BOOL finished) {
            self.uiMtn.hidden = NO;
            self.uiLst.hidden = NO;
            iMenuMoving = NO;
        }];
    }
}
@end
