//
//  AIKrakenExchangeAPIController.m
//  AIKrakenExchangeAPIController
//
//  Created by X on 19.03.14.
//  Copyright (c) 2014 andinfinity. All rights reserved.
//
#define VERSION 0.3

#import "AIKrakenExchangeAPIController.h"

@implementation AIKrakenExchangeAPIController

@synthesize protocolVersion;

- (id)init
{
	self = [super init];
	
	if (self != nil)
	{
		protocolVersion = @VERSION;
	}
	
	return self;
}

- (NSDictionary *)metadata
{
	return @{
			 @"name": @"Kranken",
			 @"@url": @"kraken.com"
			 };
}

- (void)handleData:(NSData*)data
{
	self->json = [NSJSONSerialization
				  JSONObjectWithData:data
				  options:NSJSONReadingMutableContainers
				  error:nil];
}

- (NSURL *)dataURLForCurrency:(NSString*)currency
{
	NSString *currencyPair = [@"XBT" stringByAppendingString:currency];
	NSString *URL = [@"https://api.kraken.com/0/public/AssetPairs?pair=" stringByAppendingString:currencyPair];
	
	return [NSURL URLWithString:[URL stringByAppendingString:@"/money/ticker"]];
}

- (NSNumber*)avgForCurrency:(NSString*)currency
{
	NSLog(@"Not implemented yet!");
	return @0;
}

- (NSString*)currencySymbol:(NSString*)currency
{
	NSLog(@"Not implemented yet!");
	return nil;
}

- (NSDictionary *)currencies
{
	return @{
			 @"LTC": @"Litecoin",
			 @"XDG": @"Dogecoin",
			 @"NMC": @"Namecoin",
			 @"XRP": @"Ripple",
			 @"XVN": @"Ven",
			 @"EUR": @"EUR",
			 @"KRW": @"South Korean Won",
			 @"USD": @"US Dollar"
			 };
}
@end
