//
//  ISpxHome.h
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/8.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#ifndef Hualien_ISpxHome_h
#define Hualien_ISpxHome_h
#import <UIKit/UIKit.h>
@protocol ISpxHome
    -(void)spxGoPlanHome;
@end
@protocol ISpxView
    -(void)setDelegate:(id<ISpxHome>)delegate;
@end
#endif
