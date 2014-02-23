//
//  UserDefaultsController.m
//  CheckBTC
//
//  Created by Christian Schulze on 20.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#define CURRENCYDEF @"EUR"
#define REFRESHRATEDEF @90.0

#import "UserDefaultsController.h"

@implementation UserDefaultsController

/* 
 TODO
	* provide user defaults with file
		* restore user defaults from file, not programmaticly
 */

- (id) init
{
	self = [super init];
	
	if (self != nil) {
		launchAtLoginController = [[LaunchAtLoginController alloc] init];
		userDefaults = [NSUserDefaults standardUserDefaults];
		[self checkIntegrityOfSettings];
	}
	
	return self;
}

/*!
 @abstract Check every key value pair of integrity/validity. (only at start)
 */
- (void) checkIntegrityOfSettings
{
	// >>> login item <<<
	/* If the user deleted the app from the login list, then this should not be
	 checked in preferences. Check whether this changed or not. Update the user
	 defaults accordingly. */
	[userDefaults setBool:[self doesStartAtLogin] forKey:startAtLoginKey];
	
	/* Check if currency and refreshRate were set. If not set defaults. */
	// >>> currency <<<
	NSString *_currency = [self currency];
	if (_currency == nil && [_currency length] <= 2)
		[userDefaults setObject:CURRENCYDEF forKey:currencyKey];
	
	// >>> refresh rate <<<
	double refreshRate = [self dataRefreshRate];
	if (refreshRate < 10.0)
		[userDefaults setObject:REFRESHRATEDEF forKey:refreshRateKey];
}

-(BOOL)doesStartAtLogin
{
	return [launchAtLoginController launchAtLogin];
}

# pragma mark - UserDefaultsControllerDelegateProtocol implementations

- (double)dataRefreshRate
{
	return [[userDefaults objectForKey:refreshRateKey] doubleValue];
}

- (BOOL)animateVisualRepresentation
{
	return (int) [userDefaults objectForKey:animationKey];
}

- (NSString*)currency
{
	return [userDefaults objectForKey:currencyKey];
}

- (void)setUserDefaultsWithDict:(NSDictionary*)dict
{
	/* TODO */
}

#pragma mark - interface selectors

- (void) initiateUserDefaultsWithDefaultSettings
{
	/* TODO */
}

@end
