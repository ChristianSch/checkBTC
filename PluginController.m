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

- (NSArray*)availableBundles
{
	appBundle = [NSBundle mainBundle];
	bundlePaths = [appBundle pathsForResourcesOfType:@"bundle"
										 inDirectory:@"Resources/APIControllerBundles"];
	
	NSMutableArray *bundleNames = [[NSMutableArray alloc] init];
	NSBundle *currBundle;
	
	for (int i = 0; i < [bundlePaths count]; i++)
	{
		currBundle = [NSBundle bundleWithPath:bundlePaths[i]];
		
		if (currBundle)
		{
			if ([self plugInClassIsValid:[currBundle principalClass]])
			{
				[bundleNames addObject:[[currBundle principalClass] metadata][@"name"]];
				
			} else {
				NSLog(@"%@ is not a valid bundle", currBundle);
			}
			
		}
	}
	
	return bundleNames;
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
	BOOL isValid = YES;
	
    if([plugInClass
        conformsToProtocol:@protocol(DataSourceProtocol)])
    {
		/* methods complying to protocol version 0.3 */
        if (![plugInClass instancesRespondToSelector:
			  @selector(protocolVersion)]) {
			NSLog(@"bundle does not respond to @protocolVersion!");
			isValid = NO;
			
		} else if(![plugInClass respondsToSelector:
					@selector(metadata)]) {
			NSLog(@"bundle does not respond to @metadata!");
			isValid = NO;
			
		} else if (![plugInClass instancesRespondToSelector:
					 @selector(handleData:)]) {
			NSLog(@"bundle does not respond to @handleData!");
			isValid = NO;
			
		} else if (![plugInClass instancesRespondToSelector:
					 @selector(dataURLForCurrency:)]) {
			NSLog(@"bundle does not respond to @dataURLForCurrency!");
			isValid = NO;
			
		} else if (![plugInClass instancesRespondToSelector:
					 @selector(avgForCurrency:)]) {
			NSLog(@"bundle does not respond to @avgForCurrency!");
			isValid = NO;
			
		} else if (![plugInClass instancesRespondToSelector:
					 @selector(protocolVersion)]) {
			NSLog(@"bundle does not respond to @procotolVersion!");
			isValid = NO;
			
		} else if (![plugInClass instancesRespondToSelector:
					 @selector(currencySymbol:)]) {
			NSLog(@"bundle does not respond to @currencySymbol!");
			isValid = NO;
			
		} else if (![plugInClass instancesRespondToSelector:
					 @selector(currencies)]) {
			NSLog(@"bundle does not respond to currencies!");
			isValid =  NO;
		}
	}
	
	return isValid;
}
@end
