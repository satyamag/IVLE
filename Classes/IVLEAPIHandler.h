//
//  IVLEAPIHandler.h
//  IVLE
//
//  Created by Lee Sing Jie on 3/15/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJSONDeserializer.h"
#import "IVLEAPICache.h"
#import "ModulesFetcher.h"
#import "Constants.h"

#define kDebugReceivedData 0
#define kDebugURL 0
#define kShouldPrintInternetReachability 0

#define kAPIKey @"Xi6BSlJ5TeMKFi95VF9B9"
#define kAPICacheMinutes 10

@interface IVLEAPIHandler : NSObject {
	NSDictionary *dictionary;
	BOOL dictionaryWritten;
	NSMutableData *incomingData;
	BOOL requestIsData;
	BOOL dataIsFromCoreData;
	BOOL allowCoreDataCache;
    NSString *userName;
	IVLEAPICache *cache;
}

@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) NSMutableData *incomingData;
@property (nonatomic, assign) BOOL dataIsFromCoreData;
@property (nonatomic, assign) BOOL allowCoreDataCache;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) IVLEAPICache *cache;

/* Post URL with a string of parameters denoted by p1=value&p2=value2
 REQUIRES: valid parameters format and url*/
- (NSDictionary*)postURL:(NSString*)url withParameters:(NSString*)parameters;

/* Get URL with parameters denoted by p1=value&p2=value2
 REQUIRES: valid url*/
- (NSDictionary*)getURL:(NSString*)url;

- (NSString*) getUserName:(NSString*)url;

/* Get File directly from URL. Caches permanently
 REQUIRES: valid url*/
- (NSData*)getFile:(NSString*)url;

/* Check for write in dictionary to ensure finish writing*/
- (void)checkForWriteInDictionary:(NSURLConnection*)connection;
@end
