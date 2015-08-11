//
//  BXRouterManager.h
//  Baixing
//
//  Created by phoebus on 10/11/14.
//  Copyright (c) 2014 baixing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXRouterProtocol.h"
#import "BXRouterUrl.h"

@interface BXRouterManager : NSObject

/**
 *  @return BXRouterManager singleton
 */
+ (instancetype)shareVCManager;

/**
 *  Verify router item type
 *  the router list member must be an instance of BXRouterMapItem.
 *
 *  @param routerList the app local router map list.
 *
 *  @return YES if register is successful, otherwise NO.
 */
- (BOOL)registerRouterMapList:(NSArray *)routerList;

/**
 *  Jump to the view controller which router url maped.
 *
 *  @param url      jump to router url
 *  @param delegate from view controller
 *
 *  @return the jump view controller
 */
- (UIViewController<BXRouterProtocol> *)openUrl:(BXRouterUrl *)url delegate:(UIViewController *)delegate;

@end

typedef NS_ENUM(NSInteger, BXTransformType) {
    BXTransformNone,
    BXTransformPush,
    BXTransformPop,
    BXTransformPresent
};
