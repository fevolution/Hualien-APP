//
//  SpxLifeVlg.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "VlgArchOpenMenu.h"
@interface VlgArchOpenMenu()
{
    NSMutableArray* iCellList;
}
@property(nonatomic, weak)IBOutlet UIButton* ui00_Bjaker;
@property(nonatomic, weak)IBOutlet UIButton* ui01_ArchiDesign;
@property(nonatomic, weak)IBOutlet UIButton* ui02_CommutPath;
@property(nonatomic, weak)IBOutlet UIButton* ui03_IndoorPublic;
@property(nonatomic, weak)IBOutlet UIButton* ui04_HouseRoom;
@property(nonatomic, weak)IBOutlet UIButton* ui05_IndoorDeco;
@property(nonatomic, weak)IBOutlet UIButton* ui06_Scade;
@end

//35 1236 Gap 400.333
@implementation VlgArchOpenMenu
+(id)VlgArchOpenMenu
{
    VlgArchOpenMenu *instance = [[[NSBundle mainBundle] loadNibNamed:@"VlgArchOpenMenu" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[VlgArchOpenMenu class]] )
    {
        return instance;
    }
    else
        return nil;
}

-(void)dealloc
{
    NSLog(@"%s", __func__);
}

-(void)turnOffSelected
{
    self.ui00_Bjaker.selected = NO;
    self.ui01_ArchiDesign.selected = NO;
    self.ui02_CommutPath.selected = NO;
    self.ui03_IndoorPublic.selected = NO;
    self.ui04_HouseRoom.selected = NO;
    self.ui05_IndoorDeco.selected = NO;
    self.ui06_Scade.selected = NO;
}
-(IBAction)onOptionClick:(id)sender
{
    [self turnOffSelected];
    UIButton* btn = (UIButton*)sender;
    btn.selected = YES;
    if (self.delegate)
    {
        [self.delegate onOpenMenuOption:(int)btn.tag];
    }
}
@end
