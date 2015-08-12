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
    NSAssert([url isKindOfClass:[NSString class]], @"this is a fail url.");
    
    NSMutableDictionary *urlMap = [[NSMutableDictionary alloc] init];
    
    // parse schema
    NSArray *components         = [url componentsSeparatedByString:@"://"];
    NSString *schema            = [self urlSchemaSeparatedByComponents:components];
    if ( schema ) {
        [urlMap setObject:schema forKey:kBXRouterUrlSchema];
    }

    // parse ViewController params into dictionary
    NSMutableDictionary *paramPairs = [[NSMutableDictionary alloc] init];
    
    NSArray *paramsSet = [[components objectAtIndex:1] componentsSeparatedByString:@"/"];
    NSString *vcParams = [self getVCParamsSeparatedByParamsSet:paramsSet];
    
    // url follows plist schema
    if ([vcParams rangeOfString:@"name="].length == 0) {
        [urlMap setObject:[self parseParamsByPlistSchema:vcParams] forKey:kBXRouterUrlCLassAlias];
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
        [urlMap setObject:classAlias forKey:kBXRouterUrlCLassAlias];
    
        // parse class category
        NSString *category = [self getVCJumpCategoryByParamPairs:paramPairs];
        // category might be nil
        if ( category ) {
            [urlMap setObject:category forKey:kBXRouterUrlClassCategory];
        }
    
        // parse class transform type
        NSString *transform = [self getVCTransformTypeByParamPairs:paramPairs];
        // transform type might be nil
        if ( transform ) {
            [urlMap setObject:transform forKey:kBXRouterUrlTransform];
        }
    }
    // parse parameters
    NSArray *customParamItems = [[paramsSet objectAtIndex:1] componentsSeparatedByString:@"&"];
    [urlMap setObject:[self queryParamsSeparatedByCustomParams:customParamItems] forKey:kBXRouterUrlParamMap];

    return [NSDictionary dictionaryWithDictionary:urlMap];
}

- (NSString *)parseParamsByPlistSchema:(NSString *)params
{
    NSArray *array = @[@"storyboard_controller", @"nib_controller", @"code_controller"];
    NSAssert([array containsObject:params], @"This is a failure when parse plist alias.");
    
    return params;
}


- (NSString *)urlSchemaSeparatedByComponents:(NSArray *)components
{
    NSAssert([components count] == 2, @"This is a failure when parse schema.");
    
    return [components objectAtIndex:0];
}

- (NSString *)getVCParamsSeparatedByParamsSet:(NSArray *)paramsSet
{   // some items can be null
    NSAssert([paramsSet count] > 0, @"Lack of params in url");
    
    return [paramsSet objectAtIndex:0];
}

- (NSString *)getClassAliasByParamPairs:(NSDictionary *)pairs
{
    // set class alias
    NSAssert([pairs valueForKey:@"name"], @"Lack of class alias in url params");
    
    return [pairs valueForKey:@"name"];
}

- (NSString *)getVCJumpCategoryByParamPairs:(NSDictionary *)pairs
{
    // set class category
    if ([[pairs allKeys] containsObject:@"category"]) {
        NSString *category = [pairs valueForKey:@"category"];
        NSArray *categorySet = @[@"nib",@"code"];
        BOOL categoryIsLegal = [categorySet containsObject:category];
        if ([category rangeOfString:@"storyboard:"].length > 0) {
            categoryIsLegal = YES;
        }
        NSAssert(categoryIsLegal, @"This is a failure when parsing jump category.");
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
