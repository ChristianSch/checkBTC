//
//  PluginController.h
//  CheckBTC
//
//  Created by X on 05.03.14.
//  Copyright (c) 2014 X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceProtocol.h"
#import "PluginControllerDelegateProtocol.h"

@interface PluginController : NSObject<PluginControllerDelegateProtocol>
{
	NSBundle *appBundle;
	NSArray *bundlePaths;
}

/*!
 List all available bundles that comply to the datasource protocol as a dictionary.
 @return array
 */
- (NSArray*)availableBundles;

/*!
 Load the bundle found at `path` as the plugin to use.
 @param path to bundle
 */
- (void)loadBundleAsPlugin:(NSString*)path;

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

@property (nonatomic,readonly) id<DataSourceProtocol> pluginInstance;

@end
