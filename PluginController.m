//
//  PluginController.m
//  CheckBTC
//
//  Created by X on 05.03.14.
//  Copyright (c) 2014 X. All rights reserved.
//

#import "PluginController.h"

#import "DataSourceProtocol.h"

@implementation PluginController

- (id)init
{
	self = [super init];
	
	if (self != Nil)
	{
		appBundle = [NSBundle mainBundle];
	}
	
	// testing
	NSArray *bundles = [self listBundles];
	NSLog(@"%@", bundles);
	NSLog(@"Found %lu bundles in total!", (unsigned long)[bundles count]);
	
	return self;
}

- (void)loadBundles
{
	appBundle = [NSBundle mainBundle];
	bundlePaths = [appBundle pathsForResourcesOfType:@"bundle"
										 inDirectory:@"Resources/APIControllerBundles"];
}

- (NSArray *)listBundles
{
	[self loadBundles];
	return bundlePaths;
}

- (BOOL)plugInClassIsValid:(Class)plugInClass
{
    if([plugInClass
        conformsToProtocol:@protocol(DataSourceProtocol)])
    {
		/* methods complying to protocol version 0.2.2 */
        if([plugInClass instancesRespondToSelector:
			@selector(avgForCurrency:)] &&
		   [plugInClass instancesRespondToSelector:
			@selector(currencySymbol:)] &&
		   [plugInClass instancesRespondToSelector:
			@selector(currencies)] &&
		   [plugInClass instancesRespondToSelector:
			@selector(dataURLForCurrency:)] &&
		   [plugInClass instancesRespondToSelector:
			@selector(handleData:)] &&
		   [plugInClass instancesRespondToSelector:
			@selector(protocolVersion)])
		{
			return YES;
		}
	}
	
	return NO;
}
@end
