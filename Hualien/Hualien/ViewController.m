//
//  ViewController.m
//  Hualien
//
//  Created by Chen ChunTa on 2015/3/30.
//  Copyright (c) 2015年 Chen ChunTa. All rights reserved.
//

#import "ViewController.h"
#import "HomeVCtrl.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UINavigationBar appearance] setHidden:YES];
    
    [self pushViewController:[[HomeVCtrl alloc] init] animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if ([self.view window]==nil)
    {
        self.view = nil;
    }
}

@end
