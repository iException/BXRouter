//
//  BXRouterConfig.m
//  Pods
//
//  Created by baixing on 15/8/6.
//
//

#import "BXRouterConfig.h"

@interface BXRouterConfig ()

@property (nonatomic, strong) NSString *classPrefix;

@end

@implementation BXRouterConfig

+ (instancetype)shareConfig
{
    static dispatch_once_t token;
    static BXRouterConfig *config;
    
    dispatch_once(&token, ^{
        config = [[BXRouterConfig alloc] initInstance];
    });
    
    return config;
}

- (instancetype)initInstance
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (instancetype)init
{
    return [BXRouterConfig shareConfig];
}

- (UIViewController<BXRouterProtocol> *)configureControllerByUrl:(BXRouterUrl *)url withPrefix:(NSString *)prefix
{
    if (!url.classAlias) {
        return nil;
    }
    
    _classPrefix = prefix;
    
    // configure controller
    NSString *className =  [self getClassNameByFixingClassAlias:url.classAlias];
    if (nil == className) {
        return nil;
    }
    UIViewController<BXRouterProtocol> *controller = [self getControllerByClassName:className
                                                                        andCategory:url.classCategory];
    return controller;
}

- (BXTransformType)configureTransformTypeByUrl:(BXRouterUrl *)url
{
    BXTransformType transform = BXTransformPush;
    if ([url.transform isEqualToString:@"present"]) {
        transform = BXTransformPresent;
    }
    else if ([url.transform isEqualToString:@"pop"]) {
        transform = BXTransformPop;
    }
    return transform;
}

- (NSString *)getClassNameByFixingClassAlias:(NSString *)alias
{
    NSString *className = alias;
    // if prefix exists, add to className and match first
    if ( _classPrefix ) {
        className = [_classPrefix stringByAppendingString:alias];
    }
    // if class with className exist
    if ( NSClassFromString(className) ) {
        // return className without suffix
        return className;
    } else {
        NSString *nameWithController = [className stringByAppendingString:@"Controller"];
        NSString *nameWithViewController = [className stringByAppendingString:@"ViewController"];
        if ( NSClassFromString(nameWithController) ) {
            // return className with suffix "Controller"
            return nameWithController;
        } else if ( NSClassFromString(nameWithViewController) ) {
            // return className with suffix "ViewController"
            return nameWithViewController;
        }
    }
    return nil;
}

- (UIViewController<BXRouterProtocol> *)getControllerByClassName:(NSString *)name andCategory:(NSString *)category
{
    if ([category isEqualToString:@"nib"]) {
        // return view controller from nib
        return [[NSClassFromString(name) alloc] initWithNibName:name bundle:nil];
    } else if ([category rangeOfString:@"storyboard:"].length == 0) {
        // return view controller from code
        return [[NSClassFromString(name) alloc] init];
    } else {
        // return view controller from storyboard
        NSArray *array = [category componentsSeparatedByString:@":"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[array objectAtIndex:1] bundle:nil];
        if (storyboard != nil) {
            return [storyboard instantiateViewControllerWithIdentifier:name];
        }
    }
    return nil;
}

@end
