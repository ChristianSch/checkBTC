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

@interface PluginController : NSObject <PluginControllerDelegateProtocol>
{
	NSBundle *appBundle;
	NSArray *bundlePaths;
}

@property (nonatomic, readonly) id<DataSourceProtocol> pluginInstance;

@end
