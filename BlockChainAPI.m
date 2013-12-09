//
//  BlockChainAPI.m
//  CheckBTC
//
//  Created by Christian Schulze on 05.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#import "BlockChainAPI.h"

@implementation BlockChainAPI

+ (NSDictionary*) getTicker
{
	NSString *bcTickerURLStr = @"https://blockchain.info/ticker";
	
	// create the URL we'd like to query
	NSURL *myURL = [[NSURL alloc] initWithString:bcTickerURLStr];
	
	// we'll receive raw data so we'll create an NSData Object with it
	NSData *myData = [[NSData alloc]initWithContentsOfURL:myURL];
	
	if (myData != nil) {
		// now we'll parse our data using NSJSONSerialization
		id myJSON = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableContainers error:nil];
		NSDictionary *results = myJSON;
		
		return results;
	}
	
	/*  no data returned. maybe the connection is down? */
	return nil;
}

@end
