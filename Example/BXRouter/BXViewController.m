//
//  BXViewController.m
//  BXRouter
//
//  Created by phoebus on 07/17/2015.
//  Copyright (c) 2015 phoebus. All rights reserved.
//

#import "BXViewController.h"
#import "BXRouterMapItem.h"
#import "BXRouterManager.h"

@interface BXViewController ()

@end

@implementation BXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"vcmap" ofType:@"plist"];
    NSMutableArray *array = [NSMutableArray array];
    for (id item in [NSArray arrayWithContentsOfFile:plistPath]) {
        [array addObject:[[BXRouterMapItem alloc] initWithObject:item]];
    }
    [[BXRouterManager shareVCManager] registerRouterMapList:array];
    [[BXRouterManager shareVCManager] registerClassPrefix:@"BX"];
}

- (IBAction)jumpByStoryboard:(id)sender
{
    BXRouterUrl *url = [[BXRouterUrl alloc] initWithUrl:@"bxapp://storyboard_controller/paramA=xxx&paramB=xxx"];
    [[BXRouterManager shareVCManager] openUrl:url delegate:self];
}

- (IBAction)jumpByNib:(id)sender
{
    BXRouterUrl *url = [[BXRouterUrl alloc] initWithUrl:@"bxapp://nib_controller/paramA=xxx&paramB=xxx"];
    [[BXRouterManager shareVCManager] openUrl:url delegate:self];
}

- (IBAction)jumpByCode:(id)sender
{
    [[BXRouterManager shareVCManager] resetClassPrefix];
    BXRouterUrl *url = [[BXRouterUrl alloc] initWithUrl:@"bxapp://code_controller/?"];
    [[BXRouterManager shareVCManager] openUrl:url delegate:self];
}

@end
