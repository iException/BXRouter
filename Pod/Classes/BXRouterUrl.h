//
//  BXRouterUrl.h
//  Baixing
//
//  Created by phoebus on 10/11/14.
//  Copyright (c) 2014 baixing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXRouterUrl : NSObject

/**
 *  The app CFBundleURLSchemes.
 */
@property (nonatomic, strong, readonly) NSString     *urlSchema;

/**
 *  The view controller alias.
 */
@property (nonatomic, strong, readonly) NSString     *vcAlias;

/**
 *  The url parameters，must url encode before.
 */
@property (nonatomic, strong, readonly) NSDictionary *queryParams;

/**
 *  Create a router url.
 *
 *  @param url a string which as formatted.
 *
 *  @return router url.
 */
- (instancetype)initWithUrl:(NSString *)url;

@end
