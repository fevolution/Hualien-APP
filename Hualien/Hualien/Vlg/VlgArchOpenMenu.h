//
//  SpxLifeVlg.h
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISpxHome.h"
@protocol IVlgArchOpenMenu
    -(void)onOpenMenuOption:(int)tag;
@end

@interface VlgArchOpenMenu : UIView
+(id)VlgArchOpenMenu;

@property(nonatomic, weak)id<IVlgArchOpenMenu> delegate;
@end
