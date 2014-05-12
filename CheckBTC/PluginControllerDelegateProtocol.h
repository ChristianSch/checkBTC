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
 @version 0.4
 @updated 12.05.2014
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
 Return path for the bundle named `name`.
 
 @param name of the bundle
 @discussion
 Imagine a situation where there are two different plugins with the same name. Since
 the same name indicates that they both use the same exchange for data aquisition.
 So two different plugins with the same name are not a problem at all. The plugin
 controller will return the path for the first one found. The data should be the same
 since the plugins are pretty simple and have no variation in functionallity. Additionally
 the plugins are validated.
 
 `name` will be compared with the `name` in the dictionary returned by the @metadata
 method.
 */
- (NSString*)pathForBundleName:(NSString*)name;

/*!
 Load the bundle found at `path` as the plugin to use.
 @param path to bundle
 */
- (void)loadBundleAsPluginWithPath:(NSString*)path;

/*!
 Check if file at `path` is a valid bundle.
 
 @param path of file to validate
 
 @return file is valid plugin
 */
- (BOOL)fileIsValidBundle:(NSString*)path;

/*!
 Copy bundle to the resources directory of the app
 
 @param path to bundle
 
 @return sucess
 */
- (BOOL)addBundleToResourcesDirectory:(NSString*)path
							withError:(NSError *__autoreleasing*)error;

/*!
 Checks if there exists a plugin with name `name`.
 
 @param name of bundle
 
 @return `name` is a valid bundle name
 */
- (BOOL)bundleExistsWithName:(NSString*)name;

/*!
 Returns the name of the bundle that is used for data retrieval.
 
 @return Name of Bundle
 */
- (NSString*)bundleInUse;

@end
