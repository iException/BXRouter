//
//  BXRouterManager.m
//  Baixing
//
//  Created by phoebus on 10/11/14.
//  Copyright (c) 2014 baixing. All rights reserved.
//

#import "BXRouterManager.h"
#import "BXRouterConfig.h"
#import "BXRouterMapItem.h"
#import <objc/runtime.h>

@interface BXRouterManager ()

@property (nonatomic, strong) NSArray *vcMap;

@property (nonatomic, strong, readwrite) NSString *classPrefix;

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

- (void)registerClassPrefix:(NSString *)prefix
{
    self.classPrefix = prefix;
}

- (void)resetClassPrefix
{
    self.classPrefix = @"";
}

- (BOOL)registerRouterMapList:(NSArray *)routerList
{
    __block BOOL verify = YES;
    
    [routerList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isMemberOfClass:[BXRouterMapItem class]]) {
            *stop  = YES;
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

- (UIViewController<BXRouterProtocol> *)configureControllerByPlist:(BXRouterUrl *)url {
    BXRouterMapItem *mapItem = [self mapItemByAlias:url.classAlias];
    if (!mapItem || mapItem.vcClass.length==0) {
        return nil;
    }
    // return view controller from nib
    if ([[NSBundle mainBundle] pathForResource:mapItem.vcClass ofType:@"nib"]) {
        return [[NSClassFromString(mapItem.vcClass) alloc] initWithNibName:mapItem.vcClass bundle:nil];
    }
    else {
        // return view controller from programming
        if (!mapItem.vcStoryboard || mapItem.vcStoryboard.length == 0) {
            if (! NSClassFromString(mapItem.vcClass)) {
                return nil;
            }
            return [[NSClassFromString(mapItem.vcClass) alloc] init];
        }
        // return view controller from storyboard
        else {
            if (! [[NSBundle mainBundle] pathForResource:mapItem.vcStoryboard ofType:@"storyboardc"]) {
                return nil;
            }
            if (! NSClassFromString(mapItem.vcClass)) { // 防止plist中storyboard找到而class找不到
                return nil;
            }
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:mapItem.vcStoryboard bundle:nil];
            return [storyboard instantiateViewControllerWithIdentifier:mapItem.vcClass];
        }
    }
    return nil;
}

- (BXRouterMapItem *)mapItemByAlias:(NSString *)alias
{
    for (BXRouterMapItem *mapItem in self.vcMap) {
        // 防止以后plist中也出现大写的alias
        NSString *mapLowCase   = [mapItem.alias lowercaseString];
        NSString *aliasLowCase = [alias lowercaseString];
        if ([mapLowCase compare:aliasLowCase] == NSOrderedSame) {
            return mapItem;
        }
    }
    return nil;
}

- (BXTransformType)configureTransformTypeByPlist:(NSString *)alias
{
    // default is push transition.
    BXTransformType transformType = BXTransformPush;
    
    for (BXRouterMapItem *mapItem in _vcMap) {
        if ([mapItem.alias compare:alias] == NSOrderedSame) {
            if ([mapItem.transform isEqualToString:@"present"]) {
                transformType = BXTransformPresent;
            } else {
                transformType = BXTransformPush;
                if (mapItem.unique) {
                    transformType = BXTransformPop;
                }
            }
            break;
        }
    }
    return transformType;
}

- (UIViewController<BXRouterProtocol> *)openUrl:(BXRouterUrl *)url delegate:(UIViewController *)delegate
{
    NSAssert(self.vcMap, @"please call 'registerRouterMapList' method first.");
    NSAssert([delegate isKindOfClass:[UIViewController class]], @"when open url, the delegate must be a UIViewController.");
    
    // get controller by url
    UIViewController<BXRouterProtocol> *controller = [[BXRouterConfig shareConfig] configureControllerByUrl:url withPrefix:self.classPrefix];
    
    // get transform type
    BXTransformType transform = [[BXRouterConfig shareConfig] configureTransformTypeByUrl:url];

    // can not get controller by parsing class alias, to search in plist.
    if (nil == controller) {
        controller = [self configureControllerByPlist:url];
        transform  = [self configureTransformTypeByPlist:url.classAlias];
    }
    
    // if controller can not find, return nil
    if (nil == controller) { return nil; }
    
    if (nil == delegate.navigationController) {
        // if navigationController is nil, must present,
        // or adding a root view controller as a child of view controller
        transform = BXTransformPresent;
    }
    
    // parse router url queryParams
    if ([controller respondsToSelector:@selector(queryParamsToPropertyKeyPaths:)]) {
        [controller queryParamsToPropertyKeyPaths:url];
    }
    
    // if need in a UINavigationController.
    BOOL needInNavigationController = YES;
    if ([controller respondsToSelector:@selector(needInNavigationController)]) {
        needInNavigationController = [controller needInNavigationController];
    }
    
    if (BXTransformPresent == transform) {
        if (needInNavigationController) {
            UINavigationController *navigation = [[UINavigationController alloc]
                                                  initWithRootViewController:controller];
            [delegate presentViewController:navigation animated:YES completion:^{}];
        } else {
            [delegate presentViewController:controller animated:YES completion:^{}];
        }
    } else if (BXTransformPush == transform) {
        if ([delegate isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)delegate pushViewController:controller animated:YES];
        } else {
            [delegate.navigationController pushViewController:controller animated:YES];
        }
    } else {
        BXRouterMapItem *mapItem = [self mapItemByAlias:url.classAlias];
        
        __block BOOL isPoped = NO;
        __weak NSArray *viewControllers = delegate.navigationController.viewControllers;
        if (viewControllers.count > 0) {
            [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isMemberOfClass:NSClassFromString(mapItem.vcClass)]) {
                    *stop = YES;
                    isPoped = YES;
                    [delegate.navigationController popToViewController:obj animated:YES];
                }
            }];
        }
        
        if (!isPoped) {
            [delegate.navigationController pushViewController:controller animated:YES];
        }
    }
    return controller;
}

@end
