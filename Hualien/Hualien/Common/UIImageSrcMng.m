//
//  UIImageSrcMng.m
//  Hualien
//
//  Created by Chunta chen on 7/26/15.
//  Copyright (c) 2015 Chen ChunTa. All rights reserved.
//

#import "UIImageSrcMng.h"
@interface UIImageSrcMng()
{
    NSMutableDictionary* iImgDic;
}

@end

@implementation UIImageSrcMng
+ (id)sharedManager {
    static UIImageSrcMng *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
- (UIImage*)requestImage:(NSString*)filename
{
    if (iImgDic==nil)
    {
        iImgDic = [[NSMutableDictionary alloc] init];
    }
    NSLog(@"requestImage %lu",  [iImgDic count]);
    UIImage* img = [iImgDic objectForKey:filename];
    if (img==nil)
    {
        NSString *myImagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",filename]];
        img = [[UIImage alloc] initWithContentsOfFile:myImagePath];
        [iImgDic setObject:img forKey:filename];
    }
    return img;
}
@end
