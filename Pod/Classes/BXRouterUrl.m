//
//  BXRouterUrl.m
//  Baixing
//
//  Created by phoebus on 10/11/14.
//  Copyright (c) 2014 baixing. All rights reserved.
//

#import "BXRouterUrl.h"
#import <NSString+BXURLEncode.h>

NSString *const kBXRouterUrlSchema   = @"schema";
NSString *const kBXRouterUrlAlias    = @"alias";
NSString *const kBXRouterUrlParamMap = @"paramMap";

@interface BXRouterUrl ()

@property (nonatomic, strong, readwrite) NSString *urlSchema;
@property (nonatomic, strong, readwrite) NSString *vcAlias;
@property (nonatomic, strong, readwrite) NSDictionary *queryParams;

@end

@implementation BXRouterUrl

- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        NSDictionary *urlMap = [self parseUrl:[url urlEncode]];
        self.urlSchema       = [urlMap objectForKey:kBXRouterUrlSchema];
        self.vcAlias         = [urlMap objectForKey:kBXRouterUrlAlias];
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

    // parse alias
    NSArray *vcparams = [[components objectAtIndex:1] componentsSeparatedByString:@"/?"];
    NSString *alias   = [self vcAliasSeparatedByComponents:vcparams];
    if ( alias ) {
        [urlMap setObject:alias forKey:kBXRouterUrlAlias];
    }

    // parse parameters
    NSArray *parameters = [[vcparams objectAtIndex:1] componentsSeparatedByString:@"&"];
    [urlMap setObject:[self queryParamsSeparatedByComponents:parameters] forKey:kBXRouterUrlParamMap];

    return [NSDictionary dictionaryWithDictionary:urlMap];
}

- (NSString *)urlSchemaSeparatedByComponents:(NSArray *)components
{
    NSAssert([components count] == 2, @"This is a failure when parse schema.");
    
    return [components objectAtIndex:0];
}

- (NSString *)vcAliasSeparatedByComponents:(NSArray *)components
{
    NSAssert([components count] == 2, @"This is a failure when parse alias.");
    
    return [components objectAtIndex:0];
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
