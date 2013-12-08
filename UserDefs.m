//
//  Preferences.m
//  CheckBTC
//
//  Created by Christian Schulze on 06.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import "UserDefs.h"

@implementation UserDefs

- (id)init
{
	if (!self) {
		self = [super init];
	}
	
	defaultPrefs = [NSMutableDictionary dictionary];
	
	// equals [defaultPrefs setObject:@"EUR" forKey:@"currency"];
	defaultPrefs[@"currency"] = @"EUR";
	defaultPrefs[@"refreshRate"] = @30.0;
	
	prefs = [NSUserDefaults standardUserDefaults];
	/* [prefs registerDefaults:defaultPrefs]; */
	
	return self;
}

- (id)initWithDefaultPreferences:(NSDictionary *)dict
{
	if (!self) {
		self = [super init];
	}
	
	prefs = [NSUserDefaults standardUserDefaults];
	[prefs registerDefaults:dict];
	
	return self;
}

- (void)setDefaultPreferences
{
	[prefs registerDefaults:defaultPrefs];
}

- (void)setPreferences:(NSDictionary *)dict
{
	[prefs registerDefaults:dict];
}

- (NSDictionary *)getPreferences
{
	[NSUserDefaults ]
	return nil;
}

- (id)getPreferencesForKey:(NSString *)key
{
	return [prefs objectForKey:key];
}
@end
