//
//  BXRouterConfig.h
//  Pods
//
//  Created by baixing on 15/8/6.
//
//

#import <Foundation/Foundation.h>
#import "BXRouterUrl.h"
#import "BXRouterProtocol.h"

@interface BXRouterConfig : NSObject

typedef NS_ENUM(NSInteger, BXTransformType) {
    BXTransformNone,
    BXTransformPush,
    BXTransformPop,
    BXTransformPresent
};

/**
 *  @return BXRouterConfig singleton
 */
+ (instancetype)shareConfig;

- (UIViewController<BXRouterProtocol> *)configureControllerByUrl:(BXRouterUrl *)url
                                                      withPrefix:(NSString *)prefix;

- (BXTransformType)configureTransformTypeByUrl:(BXRouterUrl *)url;

@end