//
//  MtgoxAPI.h
//  CheckBTC
//
//  Created by X on 15.12.13.
//  Copyright (c) 2013 X. All rights reserved.
//

#define BASE_URL @"https://data.mtgox.com/api/2/"
#define USER_AGENT @"CheckBTC MtGox API"

#import <Foundation/Foundation.h>

@interface MtgoxAPI : NSObject

extern NSDictionary *const currencies;

/*!
 @abstract Returns the base URL for all MtGox Api calls (in dependency of a currency supported by the APi)
 @param curr The currency to set
 @return the requested URL for API calls
 */
+ (NSString *) getBaseURLForCurrency:(NSString *)curr;

/*!
 @abstract Gets the JSON data available at the URL
 @param url URL to retrieve the JSON from
 @return the requested JSON data as a NSDictionary
 */
+ (NSDictionary *) getJSONFromURL:(NSURL *)url;

/*!
 @abstract Returns full ticker data for a given currency.
 @param curr Currency to request data for
 @return Key-Value pairs with the data
 @see https://bitbucket.org/nitrous/mtgox-api/overview#markdown-header-requests
 */
+ (NSDictionary *) getTickerForCurrency:(NSString *)curr;

/*!
 @abstract Gets the average price of one Bitcoin for a given currency.
 @param curr Currency to request data for
 @return average exchange rate
 */
+ (NSNumber *) getAvgForCurrency:(NSString *)curr;

/*!
 @abstract Gets the (unicode) symbol of the given currency
 @param curr Currency to return the symbol for
 @return the requested symbol
 @see https://bitbucket.org/nitrous/mtgox-api/overview#markdown-header-currencies
 */
+ (NSString *) getCurrencySymbol:(NSString *)curr;
@end
