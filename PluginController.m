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

@synthesize pluginInstance;

- (id)init
{
	self = [super init];
	
	if (self != Nil)
	{
		appBundle = [NSBundle mainBundle];
	}
	
	return self;
}

- (NSDictionary*)availableBundles
{
	appBundle = [NSBundle mainBundle];
	bundlePaths = [appBundle pathsForResourcesOfType:@"bundle"
										 inDirectory:@"Resources/APIControllerBundles"];
	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	// NSMutableArray *instances = [[NSMutableArray alloc] init];
	NSBundle *currBundle;
	
	for (int i = 0; i < [bundlePaths count]; i++)
	{
		currBundle = [NSBundle bundleWithPath:bundlePaths[i]];
		
		if (currBundle)
		{
			if ([self plugInClassIsValid:[currBundle principalClass]])
			{
				[dict setObject:bundlePaths[i] forKey:[[[currBundle principalClass] metadata]
												   objectForKey:@"name"]];
				
			} else {
				NSLog(@"%@ is not a valid bundle", currBundle);
			}
			
		}
	}
	
	return dict;
}

- (void)loadBundleAsPlugin:(NSString*)path
{
	NSBundle *bundle = [NSBundle bundleWithPath:path];

	if ([self plugInClassIsValid:[bundle principalClass]])
	{
		pluginInstance = [[[bundle principalClass] alloc] init];
		
	} else {
		NSLog(@"%@ is not a valid bundle!", bundle);
	}
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
			@selector(protocolVersion)] &&
		   [plugInClass instancesRespondToSelector:
			@selector(metadata)])
		{
			return YES;
		}
	}
	
	return NO;
}
@end
