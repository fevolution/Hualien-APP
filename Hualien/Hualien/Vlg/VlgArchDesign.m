//
//  SpxLifeVlg.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "VlgArchDesign.h"
//#import "VlgArchOpenMenu.h"

#import "VlgArchDesign_00DesignConcept.h"
#import "VlgArchDesign_01DesignConcept.h"
#import "VlgArchDesign_02ComPath.h"
#import "VlgArchDesign_03InteriorPublic.h"
#import "VlgArchDesign_04HouseRoom.h"

#import "HLIntroScnCell.h"
@interface VlgArchDesign()/*<IVlgArchOpenMenu>*/
{
    UIView* iActiveView;
    NSMutableArray* iNamelist;
    NSMutableArray* iCellList;
    //VlgArchOpenMenu* iOpenMenu;
}

@end

//35 1236 Gap 400.333
@implementation VlgArchDesign
+(id)VlgArchDesign
{
    VlgArchDesign *instance = [[[NSBundle mainBundle] loadNibNamed:@"VlgArchDesign" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[VlgArchDesign class]] )
    {
        return instance;
    }
    else
        return nil;
}

-(void)awakeFromNib
{
    /*
    iOpenMenu = [VlgArchOpenMenu VlgArchOpenMenu];
    [self addSubview:iOpenMenu];
    iOpenMenu.delegate = self;
    */
    iNamelist = [[NSMutableArray alloc] initWithObjects:@"VlgArchDesign_00DesignConcept", @"VlgArchDesign_01DesignConcept", @"VlgArchDesign_02ComPath", @"VlgArchDesign_03InteriorPublic", @"VlgArchDesign_04HouseRoom", @"VlgArchDesign_05InteriorDeco", @"VlgArchDesign_06Scadi", nil];
}

-(void)dealloc
{
    NSLog(@"%s", __func__);
}

-(void)switchToViewByString:(NSString*)viewstr
{
    if (iActiveView && YES==[iActiveView isKindOfClass:NSClassFromString(viewstr)])
    {
        NSLog(@"Already has same name");
        [self bringSubviewToFront:iActiveView];
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
    [self addSubview:instance];
    iActiveView = instance;

}
-(void)switch2OpenMenu
{
    //[self bringSubviewToFront:iOpenMenu];
}

#pragma mark - VLG menu delegate
-(void)onOpenMenuOption:(int)tag
{
    [self switchToViewByString:[iNamelist objectAtIndex:tag]];
}
@end
