//
//  BXCodeViewController.m
//  BXRouter
//
//  Created by phoebus on 7/17/15.
//  Copyright (c) 2015 phoebus. All rights reserved.
//

#import "BXCodeViewController.h"

@interface BXCodeViewController ()

@end

@implementation BXCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSStringFromClass([self class]);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    self.view.backgroundColor = [UIColor redColor];
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
