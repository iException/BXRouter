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
 *  The class alias, can be class full name or alias waiting for prefix & suffix.
 */
@property (nonatomic, strong, readonly) NSString     *classAlias;

/**
 *  The class category, can be storyboard=xxx or nib or code.
 */
@property (nonatomic, strong, readonly) NSString     *classCategory;

/**
 *  The view controller transform style, can be present, push or pop.
 */
@property (nonatomic, strong, readonly) NSString     *transform;

/**
 *  The url parameters，must url encode before.
 */
@property (nonatomic, strong, readonly) NSDictionary *queryParams;

/**
 *  Create a router url.
 *
 *  @param url a string which as formatted.
 *  urlFormat: bxapp://ClassName/classCategory/transform/paramA=xxx&paramB=xxx
 *      ClassName:     can be class full name or alias which is necessary.
 *      classCategory: can be "code", "nib", "storyboard=XXX".               default:code
 *      transform:     can be "push", "pop", "present".                      default:push
 *
 *  @return router url.
 */
- (instancetype)initWithUrl:(NSString *)url;

@end
