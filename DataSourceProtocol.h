//
//  DataSourceProtocol.h
//  CheckBTC
//
//  Created by Christian Schulze on 22.02.14.
//  Copyright (c) 2014 Christian Schulze. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @header DataSource Callback Protocol
 This protocol provides the necessarcy selectors to obtain the needed data by an API
 implementation.
 @author Christian Schulze
 @copyright Christian Schulze, andinfinity
 @version 0.2.3
 @updated 19.03.14
 @discussion Maybe this should be renamed because something like dataSoure already
 exists. If the plugin API (and controllers) are implemented fast enough this is
 obsolete in any case.
 */
@protocol DataSourceProtocol <NSObject>
/*!
 Protocol version formatted like 0.1
 @return version
 */
- (NSNumber *)protocolVersion;

/*!
 Metadata about the data source.
 @return data
 @discussion
 Metadata format:
 {
 name: name of source
 url: base url of source (main site, not api url)
 }
 */
- (NSDictionary *)metadata;

/*!
 @abstract Analyze the retrieved data
 @param data retrieved data
 */
- (void)handleData:(NSData*)data;

/*!
 @abstract Provide the URL to request data for the currency from
 @param currency
 @return URL to retrieve data from
 */
- (NSURL *)dataURLForCurrency:(NSString*)currency;

/*!
 @abstract Get average value for a given currency
 @param currency
 @return average
 */
- (NSNumber*)avgForCurrency:(NSString*)currency;

/*!
 @abstract Get symbolic representation of a currency
 @param currency
 @return string representation of symbol
 */
- (NSString*)currencySymbol:(NSString*)currency;

/*!
 Supported currencies.
 @return currencies
 @discussion
 Format: Short name : long name. For example:
 @"USD": @"US Dollar"
 */
- (NSDictionary *)currencies;

@end
