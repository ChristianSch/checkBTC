//
//  PluginController.h
//  CheckBTC
//
//  Created by X on 05.03.14.
//  Copyright (c) 2014 X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceProtocol.h"

@interface PluginController : NSObject
{
	NSBundle *appBundle;
	NSArray *bundlePaths;
}

/*!
 List all available bundles that comply to the datasource protocol as a dictionary.
 @return dictionary
 @discussion
 Dictionary format:
	{ BundleName : BundlePath }
*/
- (NSDictionary*)availableBundles;

/*!
 Load the bundle found at `path` as the plugin to use.
 @param path to bundle
 */
- (void)loadBundleAsPlugin:(NSString*)path;


@property (nonatomic,readonly) id<DataSourceProtocol> pluginInstance;

@end
