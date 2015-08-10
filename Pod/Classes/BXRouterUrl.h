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
 *  urlFormat: bxapp://name=xxx&category=xxx&transform=xxx/paramA=xxx&paramB=xxx
 *      ClassName:     can be class full name or alias.
 *                     * full name can not contain class prefix or you need to call 
 *                       resetPrefix method to reset prefix to null.
 *                     * alias can be key words because Router can automatically append
 *                       suffix: "Controller"or"ViewController" and prefix to search class.
 *                     * class name is case－sensitive, better to follow UpperCamelCase or own rules.
 *                     * e.g., "name=Router" with prefix:BX can jump to controller: "BXRouter",
 *                                                                                  "BXRouterController",
 *                                                                                  "BXRouterViewController"
 *      classCategory: can be "code", "nib", "storyboard:XXX".           default:code
 *      transform:     can be "push", "pop", "present".                  default:push
 *  class name is case－sensitive, better to follow UpperCamelCase or own rules.
 *
 *  @return router url.
 */
- (instancetype)initWithUrl:(NSString *)url;

@end
