//
//  UserDefaultsController.m
//  CheckBTC
//
//  Created by Christian Schulze on 20.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#import "UserDefaultsController.h"

@implementation UserDefaultsController

- (id) init
{
	self = [super init];
	
	if (self != nil) {
		launchAtLoginController = [[LaunchAtLoginController alloc] init];
		userDefaults = [NSUserDefaults standardUserDefaults];
		
		[self validateUserDefaults];
	}
	
	return self;
}

- (void)validateUserDefaults
{
	NSString *defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"standardUserDefaults" ofType:@"plist"];
	NSDictionary *defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
	[userDefaults registerDefaults:defaultPreferences];
	
	// >>> login item <<<
	/* If the user deleted the app from the login list, then this should not be
	 checked in preferences. Check whether this changed or not. Update the user
	 defaults accordingly. */
	[userDefaults setBool:[self doesStartAtLogin] forKey:startAtLoginKey];
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
	return (BOOL) [[userDefaults objectForKey:animationKey] integerValue];
}

- (NSString*)currency
{
	return [userDefaults objectForKey:currencyKey];
}

- (void)userDefaultsWithDict:(NSDictionary*)dict
{
	for( NSString *aKey in dict )
	{
		[userDefaults setObject:dict[aKey] forKey:aKey];
	}
}

- (id)userDefaultForKey:(NSString*)key
{
	return [userDefaults objectForKey:key];
}
@end
