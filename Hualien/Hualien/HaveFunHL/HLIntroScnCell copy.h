//
//  HLScnCell.h
//  Hualien
//
//  Created by Chen ChunTa on 2015/3/31.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    FIRST_IMG,
    SECOND_IMG
}IMG_OPTION;
@protocol IHLIntroScnCellDelegate
    -(void)ScnCellClickToFullScreen:(UIImage*)image;
@end
@interface HLIntroScnCell : UIView
-(id)initWithSclSize:(CGSize)ssize FstImg:(NSString*)fstr SecImg:(NSString*)sstr Page:(BOOL)enablePage AutoSlide:(BOOL)autoslide;
-(void)enableFullScreen:(IMG_OPTION)option Delegate:(id<IHLIntroScnCellDelegate>)del;
-(void)showArrow;
-(void)hidePageCtrl;
@end
