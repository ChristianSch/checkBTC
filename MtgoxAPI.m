//
//  MtgoxAPI.m
//  CheckBTC
//
//  Created by X on 15.12.13.
//  Copyright (c) 2013 X. All rights reserved.
//

#import "MtgoxAPI.h"

NSDictionary *const currencies = nil;

@implementation MtgoxAPI

#pragma mark - Data setup

+ (NSString *) getBaseURLForCurrency:(NSString *)curr
{
	/* set up the string consisting of the given currency and BTC,
	 i.e. BTCEUR or BTCUSD */
	NSString *currencyPair = [@"BTC" stringByAppendingString:curr];
	
	/* set up the url, i.e. http://data.mtgox.com/api/2/BTCEUR/money/ticker */
	NSString *url = [BASE_URL stringByAppendingString:currencyPair];
	return url;
}

#pragma mark - Data retrieval

+ (NSDictionary *) getJSONFromURL:(NSURL *)url
{
	NSData *data = [[NSData alloc]initWithContentsOfURL:url];
	
	if (data != nil) {
		// now we'll parse our data using NSJSONSerialization
		id myJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
		NSDictionary *results = myJSON;
		
		return results;
	}
	
	NSLog(@"no json returned");
	/*  no data returned. maybe the connection is down? */
	return nil;
	
}

# pragma mark - Access to processed Data
+ (NSDictionary *) getTickerForCurrency:(NSString *)curr
{
	/* set up the url, i.e. http://data.mtgox.com/api/2/BTCEUR/money/ticker */
	NSString *url = [[self getBaseURLForCurrency:curr] stringByAppendingString:@"/money/ticker"];
	
	return [self getJSONFromURL:[[NSURL alloc] initWithString:url]];
}

+ (NSNumber *) getAvgForCurrency:(NSString *)curr
{
	NSDictionary *tickerData = [self getTickerForCurrency:curr];
	
	if (tickerData != nil && [tickerData[@"result"] isEqualToString:@"success"]) {
		NSString *num = tickerData[@"data"][@"avg"][@"value"];
		return [[NSNumber alloc] initWithDouble:[num doubleValue]];
	}
	NSLog(@"An error occured while retrieving the data.");
	/* No data returned */
	return nil;
}

#pragma mark - Access to meta data

+ (NSString *) getCurrencySymbol:(NSString *)curr
{
	if ([curr isEqualToString:@"USD"]) {
		/* US Dollar */
		return @"$";
	} else if ([curr isEqualToString:@"GBP"]) {
		/* Great British Pound */
		return @"\u00a3";
	} else if ([curr isEqualToString:@"EUR"]) {
		/* Euro	*/
		return @"\u20ac";
	} else if ([curr isEqualToString:@"JPY"]) {
		/* Japanese Yen	*/
		return @"\u00a5";
	} else if ([curr isEqualToString:@"AUD"]) {
		/* Australian Dollar */
		return @"AU$";
	} else if ([curr isEqualToString:@"CAD"]) {
		/* Canadian Dollar */
		return @"CA$";
	} else if ([curr isEqualToString:@"CHF"]) {
		/* Swiss Franc */
		return @"CHF";
	} else if ([curr isEqualToString:@"CNY"]) {
		/* Chinese Yuan	*/
		return @"\u5143";
	} else if ([curr isEqualToString:@"DKK"]) {
		/* Danish Krone	*/
		return @"Kr";
	} else if ([curr isEqualToString:@"HKD"]) {
		/* Hong Kong Dollar	*/
		return @"HK$";
	} else if ([curr isEqualToString:@"PLN"]) {
		/* Polish Złoty	*/
		return @"z\u0142";
	} else if ([curr isEqualToString:@"RUB"]) {
		/* Russian Rouble */
		return @"RUB";
	} else if ([curr isEqualToString:@"SEK"]) {
		/* Swedish Krona */
		return @"Kr";
	} else if ([curr isEqualToString:@"SGD"]) {
		/* Singapore Dollar	*/
		return @"SG$";
	} else if ([curr isEqualToString:@"THB"]) {
		/* Thai Baht */
		return @"\u0e3f";
	} else if ([curr isEqualToString:@"NOK"]) {
		/* Norwegian Krone */
		return @"Kr";
	} else if ([curr isEqualToString:@"CZK"]) {
		/* Czech Koruna	*/
		return @"CZK";
	}
	return nil;
}
@end
