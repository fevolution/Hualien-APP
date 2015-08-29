//
//  UIImage+ImageFile.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/4/21.
//  Copyright (c) 2015å¹´ Chen ChunTa. All rights reserved.
//

#import "UIImage+ImageFile.h"
#import <objc/runtime.h>
static const char kNumberKey;

@implementation UIImage (ImageFile)

- (void)setSr_filename:(NSString *)sr_filename {
    objc_setAssociatedObject(self, &kNumberKey, sr_filename, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)sr_filename {
    return objc_getAssociatedObject(self, &kNumberKey);
}

-(void)dealloc
{
    if (self.sr_filename)
    {
        NSLog(@"%@", self.sr_filename);
    }
    
}
@end