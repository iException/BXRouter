//
//  BXRouterProtocol.h
//  Baixing
//
//  Created by phoebus on 7/16/15.
//  Copyright (c) 2015 Baixing. All rights reserved.
//

@class BXRouterUrl;

@protocol BXRouterProtocol <NSObject>

/**
 *  This is use for remap queryParams to property names.
 *
 *  @param url router url.
 */
- (void)queryParamsToPropertyKeyPaths:(BXRouterUrl *)url;

/**
 *  When transition is present, if need in a UINavigationController.
 *
 *  @return default YES.
 */
- (BOOL)needInNavigationController;

@end
