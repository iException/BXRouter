//
//  BXRouterMapItem.h
//  Baixing
//
//  Created by phoebus on 10/11/14.
//  Copyright (c) 2014 baixing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXRouterMapItem : NSObject

/**
 *  YES if item is unique in UINavigationcontroller.
 */
@property (nonatomic, assign, readonly) BOOL unique;

/**
 *  YES if item is translucent.
 */
@property (nonatomic, assign, readonly) BOOL translucent;

/**
 *  Assign storyboard name, if not need storyboard, set nil.
 */
@property (nonatomic, strong, readonly) NSString *vcStoryboard;

/**
 *  The view controller class name.
 */
@property (nonatomic, strong, readonly) NSString *vcClass;

/**
 *  The view controller alias name.
 */
@property (nonatomic, strong, readonly) NSString *alias;

/**
 *  The view controller transform style.
 */
@property (nonatomic, strong, readonly) NSString *transform;

/**
 *  Create a router map item.
 *
 *  @param object data source object.
 *
 *  @return router map item.
 */
- (instancetype)initWithObject:(id)object;

@end
