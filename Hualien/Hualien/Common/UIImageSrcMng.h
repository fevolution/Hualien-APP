//
//  UIImageSrcMng.h
//  Hualien
//
//  Created by Chunta chen on 7/26/15.
//  Copyright (c) 2015 Chen ChunTa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIImageSrcMng : NSObject
+ (id)sharedManager;
- (UIImage*)requestImage:(NSString*)filename;
@end
