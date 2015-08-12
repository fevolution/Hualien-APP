//
//  HLIntroSclCell.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/3/30.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "HLIntroSclCell.h"
@interface HLIntroSclCell()
{
    BOOL iInit;
    int iTopXOffset;
}
@property(nonatomic, copy)NSString* topTxt;
@property(nonatomic, copy)NSString* botTxt;
@property(nonatomic, assign)CGSize iSize;
@property(nonatomic, weak)UIImageView *uiTopTxt;
@end

@implementation HLIntroSclCell

-(id)initWithSclSize:(CGSize)ssize TopTxt:(NSString*)topstr BotTxt:(NSString*)botstr
{
    self = [super init];
    if (self)
    {
        self.topTxt = topstr;
        self.botTxt = botstr;
        self.iSize = ssize;
    }
    return self;
}


-(void)didMoveToSuperview
{
    if (iInit==NO)
    {
        if (self.topTxt && self.botTxt)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage* topimg = [UIImage imageNamed:self.topTxt];
                UIImage* botimg = [UIImage imageNamed:self.botTxt];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImageView* topv = [[UIImageView alloc] initWithImage:topimg];
                    UIImageView* botv = [[UIImageView alloc] initWithImage:botimg];
                    self.uiTopTxt = topv;
                    float ratiotoph = self.iSize.width/topimg.size.width;
                    [self addSubview:topv];
                    topv.frame = CGRectMake(iTopXOffset, 0, self.iSize.width, topimg.size.height*ratiotoph);
                    ratiotoph = self.iSize.width/botimg.size.width;
                    [self addSubview:botv];
                    botv.frame = CGRectMake(0, self.iSize.height-botimg.size.height*ratiotoph, self.iSize.width, botimg.size.height*ratiotoph);
                });
            });
        }
        iInit = YES;
    }
}

-(void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

-(void)setTopTextXOffset:(int)xoffset
{
    iTopXOffset = xoffset;
    self.uiTopTxt.frame = CGRectMake(xoffset, self.uiTopTxt.frame.origin.y, self.uiTopTxt.frame.size.width, self.uiTopTxt.frame.size.height);
}
@end
