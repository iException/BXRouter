//
//  BXRouterConfig.h
//  Pods
//
//  Created by baixing on 15/8/6.
//
//

#import <Foundation/Foundation.h>
#import "BXRouterUrl.h"

@interface BXRouterConfig : NSObject

/**
 *  @return BXRouterConfig singleton
 */
+ (instancetype)shareConfig;

- (NSDictionary *)configureControllerByUrl:(BXRouterUrl *)url withClassPrefix:(NSString *)prefix;

@end
