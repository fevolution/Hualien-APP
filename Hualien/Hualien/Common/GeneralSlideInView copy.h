//
//  GeneralSlideInView.h
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/17.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralSlideInCell.h"
#define CELL_MOVEIN_DURATION .6
#define XOFFSET_RATIO 0.76
#define XOFFSET_VALUE 778
#define PAGEARROW_BTN_WH 32
#define PAGEARROW_BTN_MARGIN 24
@interface GeneralSlideInView : UIView<IGeneralSlideInCell>
{
    BOOL iInit;
    BOOL iAnimating;
    BOOL *iCreateList;
    int iCurIndex;
    int iPreIndex;
    int iCellNum;
    GeneralSlideInCell* iActiveCell;
}
-(void)createCellByIndex:(int)index WithContainerIn:(BOOL)cellIn DesOffsetY:(int)offsetY;
@property(nonatomic, strong)NSArray* iBSNameList;
@property(nonatomic, strong)NSArray* iDesNameList;
@property(nonatomic, strong)NSArray* iBtnList;
@property(nonatomic, strong)NSArray* iDotList;
@property(nonatomic, strong)NSArray* iLineList;
@property(nonatomic, strong)NSArray* iFixRectList;
@property(nonatomic, strong)NSMutableArray* iCellList;
@property(nonatomic, weak)IBOutlet UIView* uiCellView;
@property(nonatomic, weak)IBOutlet UIView* uiCanvasView;
@property(nonatomic, weak)IBOutlet UIButton* uiLeftArrow;
@property(nonatomic, weak)IBOutlet UIButton* uiRightArrow;
@property(nonatomic, weak)IBOutlet UIButton* uiBreathArrow;

@end
