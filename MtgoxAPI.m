//
//  MtgoxAPI.m
//  CheckBTC
//
//  Created by Christian Schulze on 15.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import "MtgoxAPI.h"

NSDictionary *const currencies = nil;

@implementation MtgoxAPI

- (id) init
{
	self = [super init];
	
	if (self) {
		json = nil;
	}
	
	return self;
}

#pragma mark - protocol implementations

- (NSURL *)dataURLForCurrency:(NSString*)currency
{
	/* set up the string consisting of the given currency and BTC,
	 i.e. BTCEUR or BTCUSD */
	NSString *currencyPair = [@"BTC" stringByAppendingString:currency];
	
	/* set up the url, i.e. http://data.mtgox.com/api/2/BTCEUR/money/ticker */
	return [NSURL URLWithString:[API_BASE_URL stringByAppendingString:currencyPair]];
}

- (void)handleData:(NSData*)data
{
	self->json = [NSJSONSerialization
				  JSONObjectWithData:data
				  options:NSJSONReadingMutableContainers
				  error:nil];
}

- (NSNumber*)getAvgForCurrency:(NSString*)currency
{
	if (self->json != nil && [self->json[@"result"] isEqualToString:@"success"]) {
		NSString *num = self->json[@"data"][@"avg"][@"value"];
		return [[NSNumber alloc] initWithDouble:[num doubleValue]];
	}
	
	NSLog(@"An error occured while processing the data.");
	return nil;
}

- (NSString*)getCurrencySymbol:(NSString*)currency
{
	if ([currency isEqualToString:@"USD"]) {
		/* US Dollar */
		return @"$";
	} else if ([currency isEqualToString:@"GBP"]) {
		/* Great British Pound */
		return @"\u00a3";
	} else if ([currency isEqualToString:@"EUR"]) {
		/* Euro	*/
		return @"\u20ac";
	} else if ([currency isEqualToString:@"JPY"]) {
		/* Japanese Yen	*/
		return @"\u00a5";
	} else if ([currency isEqualToString:@"AUD"]) {
		/* Australian Dollar */
		return @"AU$";
	} else if ([currency isEqualToString:@"CAD"]) {
		/* Canadian Dollar */
		return @"CA$";
	} else if ([currency isEqualToString:@"CHF"]) {
		/* Swiss Franc */
		return @"CHF";
	} else if ([currency isEqualToString:@"CNY"]) {
		/* Chinese Yuan	*/
		return @"\u5143";
	} else if ([currency isEqualToString:@"DKK"]) {
		/* Danish Krone	*/
		return @"Kr";
	} else if ([currency isEqualToString:@"HKD"]) {
		/* Hong Kong Dollar	*/
		return @"HK$";
	} else if ([currency isEqualToString:@"PLN"]) {
		/* Polish Złoty	*/
		return @"z\u0142";
	} else if ([currency isEqualToString:@"RUB"]) {
		/* Russian Rouble */
		return @"RUB";
	} else if ([currency isEqualToString:@"SEK"]) {
		/* Swedish Krona */
		return @"Kr";
	} else if ([currency isEqualToString:@"SGD"]) {
		/* Singapore Dollar	*/
		return @"SG$";
	} else if ([currency isEqualToString:@"THB"]) {
		/* Thai Baht */
		return @"\u0e3f";
	} else if ([currency isEqualToString:@"NOK"]) {
		/* Norwegian Krone */
		return @"Kr";
	} else if ([currency isEqualToString:@"CZK"]) {
		/* Czech Koruna	*/
		return @"CZK";
	}
	return nil;
}
@end
