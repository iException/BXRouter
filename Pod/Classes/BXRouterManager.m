//
//  BXRouterManager.m
//  Baixing
//
//  Created by phoebus on 10/11/14.
//  Copyright (c) 2014 baixing. All rights reserved.
//

#import "BXRouterManager.h"
#import "BXRouterMapItem.h"
#import <objc/runtime.h>

@interface BXRouterManager ()

@property (nonatomic, strong) NSArray *vcMap;

@end

@implementation BXRouterManager

+ (instancetype)shareVCManager
{
    static dispatch_once_t token;
    static BXRouterManager *manager;

    dispatch_once(&token, ^{
        manager = [[BXRouterManager alloc] initInstance];
    });

    return manager;
}

- (instancetype)initInstance
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)init
{
    return [BXRouterManager shareVCManager];
}

- (BOOL)registerRouterMapList:(NSArray *)routerList
{
    __block BOOL verify = YES;
    
    [routerList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isMemberOfClass:[BXRouterMapItem class]]) {
            *stop = YES;
            verify = NO;
        }
    }];
    
    if (verify) {
        self.vcMap = routerList;
    } else {
        NSAssert(verify, @"The router list member must be an instance of BXRouterMapItem.");
    }
    
    return verify;
}

- (BXRouterMapItem *)mapItemByAlias:(NSString *)alias
{
    for (BXRouterMapItem *mapItem in self.vcMap) {
        if ([mapItem.alias compare:alias] == NSOrderedSame) {
            return mapItem;
        }
    }
    return nil;
}

- (BXTransformType)getTransformTypeByAlias:(NSString *)alias
{
    // default is push transition.
    BXTransformType transformType = BXTransformPush;
    
    for (BXRouterMapItem *mapItem in _vcMap) {
        if ([mapItem.alias compare:alias] == NSOrderedSame) {
            if ([mapItem.transform isEqualToString:@"present"]) {
                transformType = BXTransformPresent;
            } else if ([mapItem.transform isEqualToString:@"pop"]) {
                transformType = BXTransformPop;
            }
            break;
        }
    }
    
    return transformType;
}

- (UIViewController<BXRouterProtocol> *)getControllerByUrl:(BXRouterUrl *)url
{
    BXRouterMapItem *mapItem = [self mapItemByAlias:url.vcAlias];
    
    if ([[NSBundle mainBundle] pathForResource:mapItem.vcClass ofType:@"nib"]) {
        // return view controller from nib
        return [[NSClassFromString(mapItem.vcClass) alloc] initWithNibName:mapItem.vcClass bundle:nil];
    } else {
        if (!mapItem.vcStoryboard || mapItem.vcStoryboard.length == 0) {
            // return view controller from programming
            return [[NSClassFromString(mapItem.vcClass) alloc] init];
        } else {
            // return view controller from storyboard
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:mapItem.vcStoryboard bundle:nil];
            if (storyboard != nil) {
                return [storyboard instantiateViewControllerWithIdentifier:mapItem.vcClass];
            }
        }
    }
    
    return nil;
}

- (UIViewController<BXRouterProtocol> *)openUrl:(BXRouterUrl *)url delegate:(UIViewController *)delegate
{
    NSAssert(self.vcMap, @"please call 'registerRouterMapList' method first.");
    
    // get controller by url
    UIViewController<BXRouterProtocol> *controller = [self getControllerByUrl:url];
    
    // parse router url queryParams
    if ([controller respondsToSelector:@selector(queryParamsToPropertyKeyPaths:)]) {
        [controller queryParamsToPropertyKeyPaths:url];
    }
    
    // get transform type
    BXTransformType transform = BXTransformNone;
    if (nil == delegate.navigationController) {
        transform = BXTransformPresent;
    } else {
        transform = [self getTransformTypeByAlias:url.vcAlias];
    }
    
    if (BXTransformPresent == transform) {
        if (delegate.navigationController == nil) {
            UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
            [delegate presentViewController:navigation animated:YES completion:^{}];
        } else {
            [delegate presentViewController:controller animated:YES completion:^{}];
        }
    } else if (BXTransformPush == transform) {
        if ([delegate isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)delegate pushViewController:controller animated:YES];
        } else if (delegate.navigationController == nil) {
            UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:delegate];
            [navigation pushViewController:controller animated:YES];
        } else {
            [delegate.navigationController pushViewController:controller animated:YES];
        }
    } else {
        BXRouterMapItem *mapItem = [self mapItemByAlias:url.vcAlias];
        __weak NSArray *viewControllers = delegate.navigationController.viewControllers;
        [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isMemberOfClass:NSClassFromString(mapItem.vcClass)]) {
                *stop = YES;
                [delegate.navigationController popToViewController:obj animated:YES];
            } else if (viewControllers.count == (idx + 1)) {
                [delegate.navigationController pushViewController:controller animated:YES];
            }
        }];
    }
    
    return controller;
}

@end
