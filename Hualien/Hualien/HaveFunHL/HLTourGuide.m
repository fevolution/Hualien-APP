//
//  HLTourGuide.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/3/30.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "HLTourGuide.h"
#import "HLTourGuideBSCell.h"

@interface HLTourGuide()
{
    
}

@property(nonatomic, weak)IBOutlet UIButton* uiSugar;
@property(nonatomic, weak)IBOutlet UIImageView* uiSugarDot;
@property(nonatomic, weak)IBOutlet UIView* uiSugarLine;

@property(nonatomic, weak)IBOutlet UIButton* uiBike;
@property(nonatomic, weak)IBOutlet UIImageView* uiBikeDot;
@property(nonatomic, weak)IBOutlet UIView* uiBikeLine;

@property(nonatomic, weak)IBOutlet UIButton* uiChitemple;
@property(nonatomic, weak)IBOutlet UIImageView* uiChitempleDot;
@property(nonatomic, weak)IBOutlet UIView* uiChitempleLine;

@property(nonatomic, weak)IBOutlet UIButton* uiRiver;
@property(nonatomic, weak)IBOutlet UIImageView* uiRiverDot;
@property(nonatomic, weak)IBOutlet UIView* uiRiverLine;

@property(nonatomic, weak)IBOutlet UIButton* uiChiko;
@property(nonatomic, weak)IBOutlet UIImageView* uiChikoDot;
@property(nonatomic, weak)IBOutlet UIView* uiChikoLine;

@property(nonatomic, weak)IBOutlet UIButton* uiFongFestival;
@property(nonatomic, weak)IBOutlet UIImageView* uiFongFestivalDot;
@property(nonatomic, weak)IBOutlet UIView* uiFongFestivalLine;

@property(nonatomic, weak)IBOutlet UIButton* uiTailuker;
@property(nonatomic, weak)IBOutlet UIImageView* uiTailukerDot;
@property(nonatomic, weak)IBOutlet UIView* uiTailukerLine;

@property(nonatomic, weak)IBOutlet UIButton* uiFarm;
@property(nonatomic, weak)IBOutlet UIImageView* uiFarmDot;
@property(nonatomic, weak)IBOutlet UIView* uiFarmLine;

@property(nonatomic, weak)IBOutlet UIButton* uiFish;
@property(nonatomic, weak)IBOutlet UIImageView* uiFishDot;
@property(nonatomic, weak)IBOutlet UIView* uiFishLine;
@end

@implementation HLTourGuide

+(id)HLTourGuide
{
    HLTourGuide *instance = [[[NSBundle mainBundle] loadNibNamed:@"HLTourGuide" owner:nil options:nil] lastObject];
    if( [instance isKindOfClass:[HLTourGuide class]] )
    {
        return instance;
    }
    else
        return nil;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    iCellNum = 9;
    self.iBtnList = [[NSArray alloc] initWithObjects:self.uiTailuker, self.uiChiko, self.uiBike, self.uiChitemple, self.uiSugar, self.uiFongFestival, self.uiFarm, self.uiRiver, self.uiFish, nil];
    self.iDotList = [[NSArray alloc] initWithObjects:self.uiTailukerDot, self.uiChikoDot, self.uiBikeDot, self.uiChitempleDot,
                     self.uiSugarDot,  self.uiFongFestivalDot, self.uiFarmDot, self.uiRiverDot,  self.uiFishDot,nil];
    self.iLineList = [[NSArray alloc] initWithObjects:self.uiTailukerLine, self.uiChikoLine, self.uiBikeLine, self.uiChitempleLine,
                      self.uiSugarLine,  self.uiFongFestivalLine, self.uiFarmLine, self.uiRiverLine, self.uiFishLine, nil];
    self.iBSNameList = [[NSArray alloc] initWithObjects:@"hl_tg_tailuker_bs.png", @"hl_tg_chiko_bs.png",
                        @"hl_tg_bike_bs.png", @"hl_tg_chitemple_bs.png",  @"hl_tg_sugar_bs.png", @"hl_tg_fongfestival_bs.png",
                        @"hl_tg_farm_bs.png", @"hl_tg_river_bs.png", @"hl_tg_fish_bs.png", nil];
    self.iDesNameList = [[NSArray alloc] initWithObjects:@"hl_tg_tailuker_des.png", @"hl_tg_chiko_des.png",
                         @"hl_tg_bike_des.png", @"hl_tg_chitemple_des.png",  @"hl_tg_sugar_des.png", @"hl_tg_fongfestival_des.png",
                         @"hl_tg_farm_des.png", @"hl_tg_river_des.png", @"hl_tg_fish_des.png", nil];
    CGRect fullrect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.iFixRectList = [[NSArray alloc] initWithObjects:
                         [NSValue valueWithCGRect:fullrect], //tailuker
                         [NSValue valueWithCGRect:fullrect], //chiko
                         [NSValue valueWithCGRect:CGRectMake(-150, 50, 958, 719)], //bike
                         [NSValue valueWithCGRect:CGRectMake(-160, 50, 1094, 733)], //chitemple
                         [NSValue valueWithCGRect:CGRectMake(0, 0, 980, 840)], //sugar
                         [NSValue valueWithCGRect:fullrect], //fongfestival
                         [NSValue valueWithCGRect:fullrect], //farm
                         [NSValue valueWithCGRect:fullrect], //river
                         [NSValue valueWithCGRect:fullrect], //fish
                         nil];
    self.iCellList = [[NSMutableDictionary alloc] init];
    iCreateList = malloc(sizeof(BOOL)*iCellNum);
    for (int i =0; i<iCellNum; i++)
    {
        iCreateList[i] = NO;
    }
    iInit = YES;
    
    [self createCellsWithContainerIn:NO DesOffsetY:123 Number:iCellNum];
}
-(void)didMoveToSuperview
{
   
}
-(void)dealloc
{

}
@end
