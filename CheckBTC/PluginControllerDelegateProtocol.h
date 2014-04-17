//
//  PluginControllerDelegateProtocol.h
//  CheckBTC
//
//  Created by X on 07.04.14.
//  Copyright (c) 2014 X. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @header Plugin Controller Delegate procotol
 Neccessary selectors for communication with the plugin controller.
 @author Christian Schulze
 @copyright Christian Schulze, andinfinity
 @version 0.2
 @updated 16.04.2014
 */
@protocol PluginControllerDelegateProtocol <NSObject>

/*!
 List all available bundles that comply to the datasource protocol as a dictionary.
 @return dictionary
 @discussion
 Dictionary format:
 { BundleName : BundlePath }
 */
- (NSArray*)availableBundles;

/*!
 Load the bundle found at `path` as the plugin to use.
 @param path to bundle
 */
- (void)loadBundleAsPluginWithPath:(NSString*)path;

/*!
 Checks if bundle `name` is a plugin.
 
 @param name of bundle
 
 @return `name` is a valid bundle name
 */
- (BOOL)isValidBundle:(NSString*)name;

@end
