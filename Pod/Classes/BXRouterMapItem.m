//
//  BXRouterMapItem.m
//  Baixing
//
//  Created by phoebus on 10/11/14.
//  Copyright (c) 2014 baixing. All rights reserved.
//

#import "BXRouterMapItem.h"

NSString * const kBXRouterMapItemVCStoryboard = @"storyboard";
NSString * const kBXRouterMapItemVCClass      = @"class";
NSString * const kBXRouterMapItemAlias        = @"alias";
NSString * const kBXRouterMapItemUnique       = @"unique";
NSString * const kBXVCMAPItemTransform        = @"transform";

@interface BXRouterMapItem ()

@property (nonatomic, assign, readwrite) BOOL        unique;
@property (nonatomic, strong, readwrite) NSString    *vcStoryboard;
@property (nonatomic, strong, readwrite) NSString    *vcClass;
@property (nonatomic, strong, readwrite) NSString    *alias;
@property (nonatomic, strong, readwrite) NSString    *transform;

@end

@implementation BXRouterMapItem

- (instancetype)initWithObject:(id)object
{
    self = [super init];
    if (self) {
        self.vcStoryboard = [object objectForKey:kBXRouterMapItemVCStoryboard];
        self.vcClass      = [object objectForKey:kBXRouterMapItemVCClass];
        self.alias        = [object objectForKey:kBXRouterMapItemAlias];
        self.unique       = [[object objectForKey:kBXRouterMapItemUnique] boolValue];
        self.transform    = [object objectForKey:kBXVCMAPItemTransform];
    }
    return self;
}

@end
