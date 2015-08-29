//
//  VlgRoomCell.h
//  Hualien
//
//  Created by Chunta chen on 7/21/15.
//  Copyright (c) 2015 Chen ChunTa. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IVlgRoomCell
-(void)onPlanViewShow;
-(void)onPlanViewHide;
-(void)onPlanViewClick:(UIImage*)image;
@end

@interface VlgRoomCell : UIView
@property(nonatomic,weak)id<IVlgRoomCell> delegate;
+(id)VlgRoomCell;
-(void)setFstImg:(NSString*)fstr SecImg:(NSString*)sst;
@end
