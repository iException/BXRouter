//
//  BXRouterUrl.m
//  Baixing
//
//  Created by phoebus on 10/11/14.
//  Copyright (c) 2014 baixing. All rights reserved.
//

#import "BXRouterUrl.h"

NSString *const kBXRouterUrlSchema        = @"schema";
NSString *const kBXRouterUrlCLassAlias    = @"alias";
NSString *const kBXRouterUrlClassCategory = @"category";
NSString *const kBXRouterUrlTransform     = @"transform";
NSString *const kBXRouterUrlParamMap      = @"paramMap";

@interface BXRouterUrl ()

@property (nonatomic, strong, readwrite) NSString *urlSchema;
@property (nonatomic, strong, readwrite) NSString *classAlias;
@property (nonatomic, strong, readwrite) NSString *classCategory;
@property (nonatomic, strong, readwrite) NSString *transform;
@property (nonatomic, strong, readwrite) NSDictionary *queryParams;

@end

@implementation BXRouterUrl

- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        NSDictionary *urlMap = [self parseUrl:url];
        if (!urlMap) {
            return self;
        }
        self.urlSchema       = [urlMap objectForKey:kBXRouterUrlSchema];
        self.classAlias      = [urlMap objectForKey:kBXRouterUrlCLassAlias];
        self.classCategory   = [urlMap objectForKey:kBXRouterUrlClassCategory];
        self.transform       = [urlMap objectForKey:kBXRouterUrlTransform];
        self.queryParams     = [urlMap objectForKey:kBXRouterUrlParamMap];
    }
    
    return self;
}

#pragma mark -
#pragma mark - General Method

- (NSDictionary *)parseUrl:(NSString *)url
{
    if (![url isKindOfClass:[NSString class]]) {
        NSAssert(NO, @"this is a fail url.");
        return nil;
    }
    
    if (url.length>0 && ![url isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSMutableDictionary *urlMap = [[NSMutableDictionary alloc] init];
    
    // parse schema
    NSArray *components = [url componentsSeparatedByString:@"://"];
    if (components.count != 2) {
        return nil;
    }
    
    NSString *appSchema = [self appSchemaSeparatedByComponents:components];
    [urlMap setObject:appSchema forKey:kBXRouterUrlSchema];

    // parse ViewController params into dictionary
    NSMutableDictionary *paramPairs = [[NSMutableDictionary alloc] init];
    
    NSString *vcSchema = [self vcSchemaSeparatedByComponents:components];
    NSArray *paramsSet = [vcSchema componentsSeparatedByString:@"/?"];
    NSString *vcParams = [self getVCParamsSeparatedByParamsSet:paramsSet];
    
    // url follows plist schema
    if ([vcParams rangeOfString:@"name="].length == 0) {
        [urlMap setObject:vcParams forKey:kBXRouterUrlCLassAlias];
    }
    else {
        NSArray *vcParamItems = [vcParams componentsSeparatedByString:@"&"];
        for (NSString *item in vcParamItems) {
            NSArray *pair = [item componentsSeparatedByString:@"="];
            if ([pair count] != 2) { continue; }
            [paramPairs setValue:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
        }
        
        // parse class alias
        NSString *classAlias = [self getClassAliasByParamPairs:paramPairs];
        if (!classAlias) {
            return nil;
        }
        [urlMap setObject:classAlias forKey:kBXRouterUrlCLassAlias];
        
        // parse class category
        NSString *category = [self getVCJumpCategoryByParamPairs:paramPairs];
        // category might be nil
        if ( category ) {
            // category might be wrong
            NSArray *categorySet = @[@"nib",@"code"];
            if ([categorySet containsObject:category]
                || [category rangeOfString:@"storyboard:"].length > 0) {
                [urlMap setObject:category forKey:kBXRouterUrlClassCategory];
            }
        }
    
        // parse class transform type
        NSString *transform = [self getVCTransformTypeByParamPairs:paramPairs];
        // transform type might be nil
        if ( transform ) {
            [urlMap setObject:transform forKey:kBXRouterUrlTransform];
        }
    }
    
    // parse parameters
    if(paramsSet.count > 1) {
        NSArray *customParamItems = [[paramsSet objectAtIndex:1] componentsSeparatedByString:@"&"];
        NSDictionary *queryParams = [self queryParamsSeparatedByCustomParams:customParamItems];
        if (queryParams.count > 0) {
            [urlMap setObject:queryParams forKey:kBXRouterUrlParamMap];
        }
    }
    return [NSDictionary dictionaryWithDictionary:urlMap];
}

- (NSString *)appSchemaSeparatedByComponents:(NSArray *)components
{
    return [components objectAtIndex:0];
}

- (NSString *)vcSchemaSeparatedByComponents:(NSArray *)components
{
    return [components objectAtIndex:1];
}

- (NSString *)getVCParamsSeparatedByParamsSet:(NSArray *)paramsSet
{   // some items can be null
    return [paramsSet objectAtIndex:0];
}

- (NSString *)getClassAliasByParamPairs:(NSDictionary *)pairs
{
    // set class alias
    if ([pairs valueForKey:@"name"]) {
        return [pairs valueForKey:@"name"];
    }
    return nil;
}

- (NSString *)getVCJumpCategoryByParamPairs:(NSDictionary *)pairs
{
    // set class category
    if ([[pairs allKeys] containsObject:@"category"]) {
        NSString *category = [pairs valueForKey:@"category"];
        return category;
    }
    return nil;
}

- (NSString *)getVCTransformTypeByParamPairs:(NSDictionary *)pairs
{
    // set class transform
    if ([[pairs allKeys] containsObject:@"transform"]) {
        return [pairs valueForKey:@"transform"];
    }
    return nil;
}

- (NSDictionary *)queryParamsSeparatedByCustomParams:(NSArray *)paramItems
{
    NSMutableDictionary *paramMap = [[NSMutableDictionary alloc] init];
    for (id item in paramItems) {
        NSArray *array = [item componentsSeparatedByString:@"="];
        if ([array count] != 2) { continue; }
        [paramMap setObject:[array objectAtIndex:1] forKey:[array objectAtIndex:0]];
    }
    
    return [NSDictionary dictionaryWithDictionary:paramMap];
}

@end
