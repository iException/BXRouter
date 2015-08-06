//
//  BXRouterConfig.m
//  Pods
//
//  Created by baixing on 15/8/6.
//
//

#import "BXRouterConfig.h"

@implementation BXRouterConfig

+ (instancetype)shareConfig
{
    static dispatch_once_t token;
    static BXRouterConfig *config;
    
    dispatch_once(&token, ^{
        config = [[BXRouterConfig alloc] initInstance];
    });
    
    return config;
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
    return [BXRouterConfig shareConfig];
}

@end
