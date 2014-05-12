//
//  PluginController.m
//  CheckBTC
//
//  Created by X on 05.03.14.
//  Copyright (c) 2014 X. All rights reserved.
//

#define BUNDLES_SUBDIR @"Resources/APIControllerBundles"

#import "PluginController.h"
#import "DataSourceProtocol.h"

@implementation PluginController

@synthesize pluginInstance;

#pragma mark - lifecycle
- (id)init
{
	self = [super init];
	
	if (self != Nil)
	{
		appBundle = [NSBundle mainBundle];
	}
	
	return self;
}

#pragma mark - interface methods

- (NSArray*)availableBundles
{
	appBundle = [NSBundle mainBundle];
	bundlePaths = [appBundle pathsForResourcesOfType:@"bundle"
										 inDirectory:BUNDLES_SUBDIR];
	
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

- (void)loadBundleAsPluginWithPath:(NSString*)path
{
	NSBundle *bundle = [NSBundle bundleWithPath:path];
	
	if ([self plugInClassIsValid:[bundle principalClass]])
	{
		pluginInstance = [[[bundle principalClass] alloc] init];
		
	} else {
		NSLog(@"%@ is not a valid bundle!", bundle);
	}
}

- (BOOL)fileIsValidBundle:(NSString*)path
{
	NSBundle *bundle = [NSBundle bundleWithPath:path];
	
	if (bundle != nil)
	{
		return [self plugInClassIsValid:[bundle principalClass]];
		
	} else {
		return NO;
	}
}

- (BOOL)addBundleToResourcesDirectory:(NSString*)path
							withError:(NSError * __autoreleasing *)error
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *destinationPath = [[appBundle resourcePath]
								 stringByAppendingPathComponent:BUNDLES_SUBDIR];
								 
	destinationPath = [destinationPath
					   stringByAppendingPathComponent:[path lastPathComponent]];
	
	if ([fileManager fileExistsAtPath:destinationPath])
	{
		/* File exists. Remove old bundle … */
		if (![fileManager removeItemAtPath:destinationPath error:error])
		{
			return NO;
		}
	}
	
	return [fileManager copyItemAtPath:path toPath:destinationPath error:error];
}

- (BOOL)bundleExistsWithName:(NSString*)name
{
	if ([self pathForBundleName:name] != nil)
		return YES;
	
	return NO;
}

- (NSString*)pathForBundleName:(NSString*)name
{
	NSBundle *currBundle;
	
	for (int i = 0; i < [bundlePaths count]; i++)
	{
		currBundle = [NSBundle bundleWithPath:bundlePaths[i]];
		
		if (currBundle)
		{
			@try {
				if ([name isEqualToString:[[currBundle principalClass] metadata][@"name"]])
				{
					return bundlePaths[i];
				}
			}
			@catch (NSException * e) {
				NSLog(@"Exception: %@", e);
			}
		}
	}
	
	NSLog(@"No such bundle: %@", name);
	return nil;
}

- (NSString*)bundleInUse
{
	return [[pluginInstance class] metadata][@"name"];
}

#pragma mark - internal methods

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
