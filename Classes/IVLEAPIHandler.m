//
//  IVLEAPIHandler.m
//  IVLE
//
//  Created by Lee Sing Jie on 3/15/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "IVLEAPIHandler.h"


@implementation IVLEAPIHandler

@synthesize dictionary;
@synthesize incomingData;
@synthesize dataIsFromCoreData;
@synthesize allowCoreDataCache;
@synthesize userName;
@synthesize cache;
- (id)init{
	self = [super init];
	
	self.dictionary = [NSDictionary dictionary];
	dictionaryWritten = NO;
	self.incomingData = nil;
	
	self.cache = nil;

	return self;
}

- (NSDictionary*)postURL:(NSString*)url withParameters:(NSString*)parameters{
	
	self.incomingData = nil;
	
	if (kDebugURL) {
		NSLog(@"Posted URL: %@", url);
		NSLog(@"Parameters: %@", parameters);
	}
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
	
	[self checkForWriteInDictionary:connection];
	
	return [NSDictionary dictionaryWithDictionary:self.dictionary];
}



- (NSString *) removeAuthTokenFrom: (NSString *) url  {
	NSArray *urlSeparated = [url componentsSeparatedByString:@"&"];
	
	int index;
	for (index=0; index<[urlSeparated count]; index++) {
		if([[urlSeparated objectAtIndex:index] hasPrefix:@"AuthToken"]){
			break;
		}
	}
	
	if (index >= [urlSeparated count]) {
		return url;
	}
	NSString *urlWithoutAuthToken = [NSString string];
	for (int i=0; i < [urlSeparated count]; i++) {
		if (i != index) {
			urlWithoutAuthToken = [urlWithoutAuthToken stringByAppendingString:[NSString stringWithFormat:@"&%@", [urlSeparated objectAtIndex:i]]];
		}
	}
	return urlWithoutAuthToken;
}



- (void) createCacheInCoreData: (NSString *) urlWithoutAuthToken  {
	self.cache = [NSEntityDescription insertNewObjectForEntityForName:@"IVLEAPICache" inManagedObjectContext:[[ModulesFetcher sharedInstance] managedObjectContext]];
	self.cache.data = nil;
	self.cache.urlWithoutAuthToken = urlWithoutAuthToken;
	self.cache.date = [NSDate date];

}
- (NSData*)getFile:(NSString*)url{
	
	self.incomingData = nil;
	allowCoreDataCache = YES;
	NSString *urlWithoutAuthToken= [self removeAuthTokenFrom: url];
	
	NSArray *array = [[ModulesFetcher sharedInstance] fetchManagedObjectsForEntity:@"IVLEAPICache" 
																	 withPredicate:[NSPredicate predicateWithFormat:@"urlWithoutAuthToken == %@",urlWithoutAuthToken]]; 
	
	if ([array count]) {
		IVLEAPICache *cacheGet = [array lastObject];
		if (cacheGet.data == nil) {
			//NSLog(@"clear invalid cache");
			[[[ModulesFetcher sharedInstance] managedObjectContext] deleteObject:cacheGet];
		}else if(kAPICacheMinutes == 0){
			
			//NSLog(@"clear expired cache");
			[[[ModulesFetcher sharedInstance] managedObjectContext] deleteObject:cacheGet];
		} 
		else{
			
			//NSLog(@"LOADED FROM COREDATA");
			return cacheGet.data;
		}
	}
	
	[self createCacheInCoreData: urlWithoutAuthToken];

	requestIsData = YES;
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	NSURLConnection *connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
	
	[self checkForWriteInDictionary:connection];
	
	return incomingData; 
}

- (NSString*) getUserName:(NSString*)url {
   
    self.incomingData = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    [self checkForWriteInDictionary:connection];
    return self.userName; 
}

- (NSDictionary*)getURL:(NSString*)url{
	
	self.incomingData = nil;
	allowCoreDataCache = YES;
	NSString *urlWithoutAuthToken= [self removeAuthTokenFrom: url];

	NSArray *array = [[ModulesFetcher sharedInstance] fetchManagedObjectsForEntity:@"IVLEAPICache" 
											 withPredicate:[NSPredicate predicateWithFormat:@"urlWithoutAuthToken == %@",urlWithoutAuthToken]]; 
	
	if ([array count]) {
		IVLEAPICache *cacheGet = [array lastObject];
		NSError *error;
		//NSLog(@"cache date%f", [cacheGet.date timeIntervalSinceNow]*-1);
		if (cacheGet.data == nil) {
			//NSLog(@"clear invalid cache");
			[[[ModulesFetcher sharedInstance] managedObjectContext] deleteObject:cacheGet];
		
		} else if([cacheGet.date timeIntervalSinceNow]*-1 > 60*kAPICacheMinutes){
			
			//NSLog(@"clear expired cache");
			[[[ModulesFetcher sharedInstance] managedObjectContext] deleteObject:cacheGet];
		}
		else{
			
			//NSLog(@"LOADED FROM COREDATA");
			return [[CJSONDeserializer deserializer] deserializeAsDictionary:cacheGet.data error:&error];
		}
	}
	
	[self createCacheInCoreData: urlWithoutAuthToken];
	
	if (kDebugURL) {
		NSLog(@"URL: %@", url);
	}
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	NSURLConnection *connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
	
	[self checkForWriteInDictionary:connection];
	
	return [NSDictionary dictionaryWithDictionary:self.dictionary];
}



- (void)checkForWriteInDictionary:(NSURLConnection*)connection{
	if (connection != nil) {
		do {
			[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
		} while (!dictionaryWritten);
	}
	dictionaryWritten = NO;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	//NSLog(@"Connection Error:%@, A blank dictionary is returned", [error localizedDescription]);
	self.dictionary = nil;
	dictionaryWritten = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	//NSLog(@"Responsed");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	if (self.incomingData == nil) {
		self.incomingData = [NSMutableData data];
	}
	[self.incomingData appendData:data];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	if (requestIsData) { //if request is data, do not parse with json parser. 
		dictionaryWritten = YES;
		requestIsData = NO;
		if (kDebugReceivedData) {
			NSLog(@"Data transfer completed, JSON parsing started.");

			NSLog(@"kDebugReceivedData(DATA):%@", incomingData);
			NSLog(@"--------------------------------------");
			
		}
	} else {
		NSString *jsonString = [[NSString alloc] initWithData:self.incomingData encoding:NSASCIIStringEncoding];
        self.userName = [NSString stringWithString:jsonString];
		NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
		NSError *error = nil;
		self.dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		dictionaryWritten = YES;
		
		if (error) {
			NSLog(@"%@", [error localizedDescription]);
		}
		if (kDebugReceivedData) {
			NSLog(@"Data transfer completed, JSON parsing started.");
			
			NSLog(@"kDebugReceivedData:%@", self.dictionary);
			NSLog(@"--------------------------------------");
			
		}
	//	self.incomingData = nil;
		
		[jsonString release];
	}
	
	if (allowCoreDataCache && self.cache != nil) {
		
		NSError *error = nil;
		//NSLog(@"saving: %@", self.cache.urlWithoutAuthToken);
		self.cache.data = 	self.incomingData;
		[[[ModulesFetcher sharedInstance] managedObjectContext] save:&error];
		if (error!=nil) {
			//NSLog(@"cd not saved!!!");
			
			NSLog(@"%@", [error localizedDescription]);
			NSAssert(0, @"CD Not Saved");
		}
		//NSLog(@"cd saved");
	}

	
}


@end
