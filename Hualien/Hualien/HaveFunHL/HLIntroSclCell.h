//
//  HLIntroSclCell.h
//  Hualien
//
//  Created by Chen ChunTa on 2015/3/30.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLIntroSclCell : UIView
-(id)initWithSclSize:(CGSize)ssize TopTxt:(NSString*)topstr BotTxt:(NSString*)botstr;
-(void)setTopTextXOffset:(int)xoffset;
@end
