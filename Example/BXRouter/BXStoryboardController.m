//
//  BXStoryboardController.m
//  BXRouter
//
//  Created by phoebus on 7/17/15.
//  Copyright (c) 2015 phoebus. All rights reserved.
//

#import "BXStoryboardController.h"

@implementation BXStoryboardController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSStringFromClass([self class]);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
}

- (void)back:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)needInNavigationController
{
    return YES;
}

@end
