//
//  HLIntroView.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/3/30.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "HLIntroView.h"
#import "HLIntroSclCell.h"
#import "HLIntroScnCell.h"
#import <QuartzCore/QuartzCore.h>
#define CELL_NUM 6
#define INDICATOR_MOVE_DURATION 0.4
#define INDICATOR_START_CENTER 110
#define INDICATOR_END 688.0

@interface HLIntroView()
{
    NSMutableArray* iLeftCellList;
    BOOL isInitBefore;
    BOOL *iCreateList;
    BOOL *iHasSec;
    int iCurIndex;
    int iBeginCY;
    CGSize iTxtSize;
    CGSize iScnSize;
    float iSlideGap;
}
@property(nonatomic, weak)IBOutlet UIScrollView* uiTxtSclView;
@property(nonatomic, weak)IBOutlet UIScrollView* uiScnSclView;
@property(nonatomic, weak)IBOutlet UIView* uiIndicatorView;
@property(nonatomic, weak)IBOutlet UILabel* uiCurPage;
@end

@implementation HLIntroView
+(id)HLIntroView
{
    HLIntroView *instance = [[[NSBundle mainBundle] loadNibNamed:@"HLIntroView" owner:nil options:nil] lastObject];
    if( [instance isKindOfClass:[HLIntroView class]] )
    {
        return instance;
    }
    else
        return nil;
}
-(void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    
    free(iCreateList);
    free(iHasSec);
}
-(void)didMoveToSuperview
{
    if (isInitBefore==NO)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 122, 165, 14)];
        
        NSString *string = @"花蓮簡介";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        
        float spacing = 1.2f;
        [attributedString addAttribute:NSKernAttributeName
                                 value:@(spacing)
                                 range:NSMakeRange(0, [string length])];
        
        label.attributedText = attributedString;
        label.textColor = [UIColor colorWithRed:176/255.0 green:176/255.0 blue:178/255.0 alpha:1];
        [label setFont:[UIFont fontWithName:@"DFLiHei-Md" size:14]];
        [self addSubview:label];
        
        
        iTxtSize = self.uiTxtSclView.frame.size;
        iScnSize = self.uiScnSclView.frame.size;
        self.uiIndicatorView.center = CGPointMake(self.uiIndicatorView.center.x, INDICATOR_START_CENTER);
        iBeginCY = self.uiIndicatorView.center.y;
        if (CELL_NUM>0)
        {
            iSlideGap = (INDICATOR_END - iBeginCY)/(CELL_NUM-1);
        }else{
            iSlideGap = 0;
        }
        iCreateList = malloc(sizeof(BOOL)*CELL_NUM);
        for( int i = 0; i<CELL_NUM; i++)
        {
            iCreateList[i] = NO;
        }
        iHasSec = malloc(sizeof(BOOL)*CELL_NUM);
        for( int i = 0; i<CELL_NUM; i++)
        {
            iHasSec[i] = YES;
            if (i>1)
            {
                iHasSec[i] = NO;
            }
        }

        //Do we have second image to animate
        self.uiIndicatorView.clipsToBounds = YES;
        [self createPageContentByIndex:iCurIndex];

        self.uiTxtSclView.contentSize = CGSizeMake(iTxtSize.width, iTxtSize.height*CELL_NUM);
        self.uiScnSclView.contentSize = CGSizeMake(iScnSize.width, iScnSize.height*CELL_NUM);
        // Gesture
        {
            UISwipeGestureRecognizer* swipegs_down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onTextSclSwipe:)];
            swipegs_down.direction = UISwipeGestureRecognizerDirectionDown;
            [self.uiTxtSclView addGestureRecognizer:swipegs_down];
            UISwipeGestureRecognizer* swipegs_up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onTextSclSwipe:)];
            swipegs_up.direction = UISwipeGestureRecognizerDirectionUp;
            [self.uiTxtSclView addGestureRecognizer:swipegs_up];
            self.uiTxtSclView.scrollEnabled = NO;
        }
        {
            UISwipeGestureRecognizer* swipegs_down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSceneSclSwipe:)];
            swipegs_down.direction = UISwipeGestureRecognizerDirectionDown;
            [self.uiScnSclView addGestureRecognizer:swipegs_down];
            UISwipeGestureRecognizer* swipegs_up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSceneSclSwipe:)];
            swipegs_up.direction = UISwipeGestureRecognizerDirectionUp;
            [self.uiScnSclView addGestureRecognizer:swipegs_up];
            self.uiScnSclView.scrollEnabled = NO;
        }
        isInitBefore = YES;
    }
}

- (void)createPageContentByIndex:(int)index
{
    if (iCreateList[index]==NO)
    {
        HLIntroSclCell* txt_cell = [[HLIntroSclCell alloc] initWithSclSize:iTxtSize
                                                                    TopTxt:[NSString stringWithFormat:@"hl_intro_c%0.2d_text01_refine.png", index+1]
                                                                    BotTxt:[NSString stringWithFormat:@"hl_intro_c%0.2d_text02_refine.png", index+1]];
        txt_cell.frame = CGRectMake(0, iTxtSize.height*index, iTxtSize.width, iTxtSize.height);
        [self.uiTxtSclView addSubview:txt_cell];
        [txt_cell setTopTextXOffset:-1];

        HLIntroScnCell* scn_scell = nil;
        if (iHasSec[index])
        {
            scn_scell = [[HLIntroScnCell alloc] initWithSclSize:iScnSize
                                                         FstImg:[NSString stringWithFormat:@"hl_intro_c%0.2d_img01.png", index+1]
                                                         SecImg:[NSString stringWithFormat:@"hl_intro_c%0.2d_img02.png", index+1]
                                                         Page:YES AutoSlide:YES];
        }else
        {
            scn_scell = [[HLIntroScnCell alloc] initWithSclSize:iScnSize
                                                         FstImg:[NSString stringWithFormat:@"hl_intro_c%0.2d_img01.png", index+1]
                                                         SecImg:nil
                                                         Page:YES AutoSlide:YES];
        }
        scn_scell.frame = CGRectMake(0, iScnSize.height*index, iScnSize.width, iScnSize.height);
        
        [self.uiScnSclView addSubview:scn_scell];
        
        iCreateList[index] = YES;
        
    }
}

- (void)moveUp
{
    iCurIndex++;
    if (iCurIndex>=CELL_NUM)
    {
        iCurIndex = CELL_NUM-1;
        return;
    }
    self.uiCurPage.text = [NSString stringWithFormat:@"%d", iCurIndex+1];
    [self createPageContentByIndex:iCurIndex];
    [self.uiTxtSclView scrollRectToVisible:CGRectMake(0, iTxtSize.height*iCurIndex, iTxtSize.width, iTxtSize.height) animated:YES];
    [self.uiScnSclView scrollRectToVisible:CGRectMake(0, iScnSize.height*iCurIndex, iScnSize.width, iScnSize.height) animated:YES];
    [UIView animateKeyframesWithDuration:INDICATOR_MOVE_DURATION delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        self.uiIndicatorView.center = CGPointMake(self.uiIndicatorView.center.x, iBeginCY+iCurIndex*iSlideGap);
    } completion:^(BOOL finished) {

    }];
}

- (void)moveDown
{
    iCurIndex--;
    if (iCurIndex<0)
    {
        iCurIndex = 0;
        return;
    }
    self.uiCurPage.text = [NSString stringWithFormat:@"%d", iCurIndex+1];
    [self createPageContentByIndex:iCurIndex];
    [self.uiTxtSclView scrollRectToVisible:CGRectMake(0, iTxtSize.height*iCurIndex, iTxtSize.width, iTxtSize.height) animated:YES];
    [self.uiScnSclView scrollRectToVisible:CGRectMake(0, iScnSize.height*iCurIndex, iScnSize.width, iScnSize.height) animated:YES];
    [UIView animateKeyframesWithDuration:INDICATOR_MOVE_DURATION delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        self.uiIndicatorView.center = CGPointMake(self.uiIndicatorView.center.x, iBeginCY+iCurIndex*iSlideGap);
    } completion:^(BOOL finished) {

    }];
}

- (void)onTextSclSwipe: (UISwipeGestureRecognizer *)sender
{
    if(sender.direction & UISwipeGestureRecognizerDirectionUp)
    {
        [self moveUp];
    }
    if(sender.direction & UISwipeGestureRecognizerDirectionDown)
    {
        [self moveDown];
    }
}

- (void)onSceneSclSwipe: (UISwipeGestureRecognizer *)sender
{
    if(sender.direction & UISwipeGestureRecognizerDirectionUp)
    {
        [self moveUp];
    }
    if(sender.direction & UISwipeGestureRecognizerDirectionDown)
    {
        [self moveDown];
    }
}
@end
