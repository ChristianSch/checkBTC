//
//  MtgoxAPI.h
//  CheckBTC
//
//  Created by Christian Schulze on 15.12.13.
//  Copyright (c) 2013 Christian Schulze. All rights reserved.
//

#define API_BASE_URL @"https://data.mtgox.com/api/2/"
#define USER_AGENT @"CheckBTC MtGox API"

#import <Foundation/Foundation.h>
#import "DataSourceProtocol.h"

@interface MtgoxAPI : NSObject <DataSourceProtocol>
{
	NSDictionary *json;
}

@end
