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

    // parse classAlias
    NSArray *vcparams = [[components objectAtIndex:1] componentsSeparatedByString:@"/"];
    NSString *alias   = [self vcAliasSeparatedByComponents:vcparams];
    if ( alias ) {
        [urlMap setObject:alias forKey:kBXRouterUrlCLassAlias];
    }
    
    // parse class category
    NSString *category = [self getVCStoryboardCategoryByComponents:vcparams];
    if ( category ) {
        [urlMap setObject:category forKey:kBXRouterUrlClassCategory];
    }
    
    // parse class category
    NSString *transform = [self getVcTransformByComponents:vcparams];
    if ( transform ) {
        [urlMap setObject:transform forKey:kBXRouterUrlTransform];
    }
    
    // parse parameters
    NSArray *parameters = [[vcparams objectAtIndex:2] componentsSeparatedByString:@"&"];
    [urlMap setObject:[self queryParamsSeparatedByComponents:parameters] forKey:kBXRouterUrlParamMap];

    return [NSDictionary dictionaryWithDictionary:urlMap];
}

- (NSString *)urlSchemaSeparatedByComponents:(NSArray *)components
{
    NSAssert([components count] == 2, @"This is a failure when parse schema.");
    
    return [components objectAtIndex:0];
}

- (NSString *)vcAliasSeparatedByComponents:(NSArray *)components
{   //懒用户可能会省略字段
    NSAssert([components count] > 0, @"This is a failure when parse alias.");
    
    return [components objectAtIndex:0];
}

- (NSString *)getVCStoryboardCategoryByComponents:(NSArray *)components
{
    NSString *category = [components objectAtIndex:1];
    NSArray *categoryCollection = @[@"nib",@"code"];
    
    BOOL categoryIsLegal = [categoryCollection containsObject:category];
    if ([category rangeOfString:@"storyboard="].length > 0) {
        categoryIsLegal = YES;
    }
    NSAssert(categoryIsLegal, @"This is a failure when parse storyboard category.");
    return category;
}

- (NSString *)getVcTransformByComponents:(NSArray *)components
{
    NSString *transformStyle = [components objectAtIndex:2];
    NSArray *styleCollection = @[@"present", @"push", @"pop"];
    
    NSAssert([styleCollection containsObject:transformStyle],
             @"This is a failure when parse view controller transform style.");
    return transformStyle;
}

- (NSDictionary *)queryParamsSeparatedByComponents:(NSArray *)components
{
    NSMutableDictionary *paramMap = [[NSMutableDictionary alloc] init];
    for (id component in components) {
        NSArray *array = [component componentsSeparatedByString:@"="];
        if ([array count] != 2) { continue; }
        [paramMap setObject:[array objectAtIndex:1] forKey:[array objectAtIndex:0]];
    }
    return [NSDictionary dictionaryWithDictionary:paramMap];
}

@end
