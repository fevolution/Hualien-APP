//
//  SpxLifeVlg.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "VlgComPath.h"
#import "GeneralFullScreenSlideShow.h"
@interface VlgComPath()<UIScrollViewDelegate>
{
    int iR;
    int iG;
    int iB;
    GeneralFullScreenSlideShow* iArchSlideShow;
    NSMutableArray* iNameList;
}
@property(nonatomic, weak)IBOutlet UIView* uiBand;
//Stage
@property(nonatomic, weak)IBOutlet UIButton* uiStageBtn;
@property(nonatomic, weak)IBOutlet UIView* uiStageLine;
@property(nonatomic, weak)IBOutlet UIImageView* uiStageDot;

//OpenKitchen
@property(nonatomic, weak)IBOutlet UIButton* uiOpenKitchenBtn;
@property(nonatomic, weak)IBOutlet UIView* uiOpenKitchenLine;
@property(nonatomic, weak)IBOutlet UIImageView* uiOpenKitchenDot;

//Indoor Run
@property(nonatomic, weak)IBOutlet UIButton* uiIndoorRunBtn;
@property(nonatomic, weak)IBOutlet UIView* uiIndoorRunLine;
@property(nonatomic, weak)IBOutlet UIImageView* uiIndoorRunDot;

//Coffee
@property(nonatomic, weak)IBOutlet UIButton* uiCoffeeBtn;
@property(nonatomic, weak)IBOutlet UIView* uiCoffeeLine;
@property(nonatomic, weak)IBOutlet UIImageView* uiCoffeeDot;

//Outdoor Run
@property(nonatomic, weak)IBOutlet UIButton* uiOutdoorRunBtn;
@property(nonatomic, weak)IBOutlet UIView* uiOutdoorRunLine;
@property(nonatomic, weak)IBOutlet UIImageView* uiOutdoorRunDot;

//Atrium
@property(nonatomic, weak)IBOutlet UIButton* uiAtriumBtn;
@property(nonatomic, weak)IBOutlet UIView* uiAtriumLine;
@property(nonatomic, weak)IBOutlet UIImageView* uiAtriumDot;

//WarmPool
@property(nonatomic, weak)IBOutlet UIButton* uiWarmPoolBtn;
@property(nonatomic, weak)IBOutlet UIView* uiWarmPoolLine;
@property(nonatomic, weak)IBOutlet UIImageView* uiWarmPoolDot;

//Pet
@property(nonatomic, weak)IBOutlet UIButton* uiPetBtn;
@property(nonatomic, weak)IBOutlet UIView* uiPetLine;
@property(nonatomic, weak)IBOutlet UIImageView* uiPetDot;
@end

//35 1236 Gap 400.333
@implementation VlgComPath
+(id)VlgComPath
{
    VlgComPath *instance = [[[NSBundle mainBundle] loadNibNamed:@"VlgComPath" owner:self options:nil] lastObject];
    if( [instance isKindOfClass:[VlgComPath class]] )
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
-(void)didMoveToSuperview
{
    if (iInit==NO)
    {
        

        self.iBtnList = [[NSArray alloc] initWithObjects:
                         self.uiIndoorRunBtn,
                         self.uiOpenKitchenBtn,
                         self.uiWarmPoolBtn,
                         self.uiCoffeeBtn,
                         self.uiStageBtn,
                         self.uiOutdoorRunBtn,
                         self.uiAtriumBtn,
                         self.uiPetBtn, nil];

        self.iDotList = [[NSArray alloc] initWithObjects:
                         self.uiIndoorRunDot,
                         self.uiOpenKitchenDot,
                         self.uiWarmPoolDot,
                         self.uiCoffeeDot,
                         self.uiStageDot,
                         self.uiOutdoorRunDot,
                         self.uiAtriumDot,
                         self.uiPetDot, nil];

        self.iLineList = [[NSArray alloc] initWithObjects:
                          self.uiIndoorRunLine,
                          self.uiOpenKitchenLine,
                          self.uiWarmPoolLine,
                          self.uiCoffeeLine,
                          self.uiStageLine,
                          self.uiOutdoorRunLine,
                          self.uiAtriumLine,
                          self.uiPetLine, nil];

        self.iBSNameList = [[NSArray alloc] initWithObjects:
                            @"vlg_01_02_indoorrun_bs.png",
                            @"vlg_01_02_openkitchen_bs.png",
                            @"vlg_01_02_warmswimpool_bs.png",
                            @"vlg_01_02_coffee_bs.png",
                            @"vlg_01_02_stage_bs.png",
                            @"vlg_01_02_outdoorrun_bs.png",
                            @"vlg_01_02_atrium_bs.png",
                            @"vlg_01_02_pet_bs.png" , nil];



        self.iDesNameList = [[NSArray alloc] initWithObjects:
                             @"vlg_01_02_indoorrun_des.png",
                             @"vlg_01_02_openkitchen_des.png",
                             @"vlg_01_02_warmswimpool_des.png",
                             @"vlg_01_02_coffee_des.png",
                             @"vlg_01_02_stage_des.png",
                             @"vlg_01_02_outdoorrun_des.png",
                             @"vlg_01_02_atrium_des.png",
                             @"vlg_01_02_pet_des.png" ,nil];

        iCellNum = 8;
        CGRect fullrect = CGRectMake(0, 0, 778, 768);
        self.iFixRectList = [[NSArray alloc] initWithObjects:
                             [NSValue valueWithCGRect:fullrect], //
                             [NSValue valueWithCGRect:fullrect], //
                             [NSValue valueWithCGRect:fullrect], //
                             [NSValue valueWithCGRect:fullrect], //
                             [NSValue valueWithCGRect:fullrect], //
                             [NSValue valueWithCGRect:fullrect], //
                             [NSValue valueWithCGRect:fullrect], //
                             [NSValue valueWithCGRect:fullrect], //
                             nil];
        self.iCellList = [[NSMutableDictionary alloc] init];
        iCreateList = malloc(sizeof(BOOL)*iCellNum);
        for (int i =0; i<iCellNum; i++)
        {
            iCreateList[i] = NO;
        }
        iInit = YES;
        
        [self createCellsWithContainerIn:NO DesOffsetY:103 Number:iCellNum];
    }
    [self bringSubviewToFront:self.uiBand];
}

@end
