//
//  SpxLifeVlg.h
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISpxHome.h"
@interface SpxCulcreate : UIView
+(id)SpxCulcreate;
-(void)setDelegate:(id<ISpxHome>)delegate;
@end