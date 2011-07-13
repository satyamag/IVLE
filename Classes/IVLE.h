//
//  IVLE.h
//  IVLE
//
//  Created by Lee Sing Jie on 3/21/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "IVLEAPIHandler.h"
#import "IVLEAPICache.h"

#define kNotificationRefreshScreen @"RefreshScreen"
#define kNotificationRefreshRightScreen @"RefreshRightScreen"
#define kDebugMemoryManagement 1
@interface IVLE : NSObject {
	IVLEAPIHandler *handler;
	NSString *authenticationToken;
	
	NSString *username;
	
	NSString *selectedCourseID;
	NSString *selectedWorkbinID;
	
}

@property (nonatomic, retain) NSString *authenticationToken;
@property (nonatomic, retain) NSString *userName;

@property (nonatomic, retain) NSString *selectedCourseID;

@property (nonatomic, retain) NSString *selectedWorkbinID;
/* Returns an instance of the IVLE object. Adopted Singleton Pattern*/
+ (IVLE *)instance;

/* Return the authetication token */

/*Login into ivle. 
 user: username
 password: password
 domain: NUSSTU/NUSSTF*/
//-(NSDictionary*)login:(NSString*)user withPassword:(NSString*)password withDomain:(NSString*)domain;

-(void) setAuthToken:(NSString *)authToken;

-(NSString*) getAndSetUserName;

- (NSDictionary *)validate;

/*Display announcements for certain courseID
 courseID: from modules
 title: title only*/
-(NSDictionary*)announcements:(NSString*)courseID withDuration:(NSInteger)duration withTitle:(BOOL)title;

/*Display class roster for certain courseID
 courseID: from modules*/
-(NSDictionary*)classRoster:(NSString*)courseID;

/*	Display module information
 REQUIRES: Valid token, valid courseID 
 NOTE: Do not set INFO = YES */
-(NSDictionary*)module:(NSString*)courseID withDuration:(NSInteger)duration withTitle:(BOOL)title withAllInfo:(BOOL)info;

/*	Display all modules information
 REQUIRES: Valid token */
-(NSDictionary*)modules:(NSInteger)duration withAllInfo:(BOOL)info;

/*	Display module information about a particular module, total lecture hours, tutorial hours etc.  
 REQUIRES: Valid token */
-(NSDictionary*)moduleInfo:(NSString*)courseID withDuration:(NSInteger)duration;

/*	Display lecturers involve in this module
 REQUIRES: Valid token */
-(NSDictionary*)moduleLecturers:(NSString*)courseID withDuration:(NSInteger)duration;

/*	Display module organizer events that user created in IVLE web app
 REQUIRES: Valid token */
-(NSDictionary*)moduleOrganizerEvents;

/*	Display readings/books required by the module. 
 REQUIRES: Valid token */
-(NSDictionary*)moduleReading:(NSString*)courseID withDuration:(NSInteger)duration;

/*	Display readings/books required by the module formatted with URL etc.. 
 REQUIRES: Valid token */
-(NSDictionary*)moduleReadingFormatted:(NSString*)courseID withDuration:(NSInteger)duration;

/*	Display readings/books required by the module formatted with COOP information. 
 REQUIRES: Valid token */
-(NSDictionary*)moduleReadingFormattedCoop:(NSString*)courseID withDuration:(NSInteger)duration;

/*	Display readings/books required by the module, raw data. 
 REQUIRES: Valid token */
-(NSDictionary*)moduleReadingUnformatted:(NSString*)courseID withDuration:(NSInteger)duration;

/*	Display weblinks of that particular module
 REQUIRES: Valid token */
-(NSDictionary*)moduleWeblinks:(NSString*)courseID withDuration:(NSInteger)duration;

/*	Display forum with/without threads of that particular forumID.
 REQUIRES: Valid token, valid forumID */
-(NSDictionary*)forum:(NSString*)forumID withDuration:(NSInteger)duration withThreads:(BOOL)thread;

/*	Display forum with/without threads of that particular forumID.
 REQUIRES: Valid token, valid forumID */
- (NSDictionary *)forums:(NSString *)courseID withDuration:(NSInteger)duration withThreads:(BOOL)thread withTitle:(BOOL)title;

/*	Display forum main topic
 REQUIRES: Valid token, valid headingID */
-(NSDictionary*)forumHeadingMainThreads:(NSString*)headingID withDuration:(NSInteger)duration;

/*	Display forum based on headingID with/without all the threads
 REQUIRES: Valid token, valid forumID */
-(NSDictionary*)forumHeadings:(NSString*)forumID withDuration:(NSInteger)duration withThreads:(BOOL)thread;

/*	Display forum threads based on headingID 
 REQUIRES: Valid token, valid headingID */
-(NSDictionary*)forumHeadingThreads:(NSString*)headingID withDuration:(NSInteger)duration;

/*	Display workbin items and structure based on workbinID
 REQUIRES: Valid token, valid courseID */
-(NSDictionary*)workbin:(NSString*)courseID withDuration:(NSInteger)duration withWorkbinID:(NSString*)workbinID withTitle:(BOOL)title;


/*	Get workbin file based on fileID
 REQUIRES: Valid token, valid fileID */
-(NSURLRequest*)workbinGetFile:(NSString*)fileID withExtension:(NSString*)ext;

//Gets the subthreads belonging to threadid
- (NSDictionary *)forumThreads:(NSString *)threadID withDuration:(NSInteger)duration withThreads:(BOOL)thread;

//Gets the thread information
- (NSDictionary *)forumThread:(NSString *)threadID;

/* Posting forum reply 
 REQUIRES: Valid token, valid thread ID*/
- (NSDictionary *)forumReplyThread:(NSString *)threadID withTitle:(NSString*)title withReply:(NSString*)reply;

/* Posting forum thread 
 REQUIRES: Valid token, valid thread ID*/
- (NSDictionary *)forumPostNewThread:(NSString *)headingID withTitle:(NSString*)title withReply:(NSString*)reply;

/* Get student Events
 REQUIRES: Valid token*/
- (NSDictionary *)studentEvents:(BOOL)title;

/*Gets webcasts
 REQUIRES: Valid token, valid courseID*/
- (NSDictionary *)webcasts:(NSString *)courseID withDuration:(NSInteger)duration withTitleOnly:(BOOL)title;

- (NSDictionary *)webcasts:(NSString *)courseID withDuration:(NSInteger)duration withMediaID:(NSString *)mediaID withTitleOnly:(BOOL)title;

/* Create user events in server
 REQUIRES: nil*/
- (NSDictionary *)userEventsCreate:(NSString*)user withContact:(NSString*)hp withTitle:(NSString*)title withDescription:(NSString*)description withPrice:(NSString*)price atLocation:(CLLocationCoordinate2D)coordinates;

/* Get user events in the last 'duration'
 REQUIRES: positive duration*/
- (NSDictionary *)userEventsGet:(NSInteger)duration;

/* Gets the related module timetable 
 information for the student. */
- (NSDictionary *)timetableStudentModule:(NSString *)courseID;

/* Gets the related student timetable 
 information for the academic semester year. */
- (NSDictionary *)timetableStudent:(NSString *)academicYear forSemester:(NSString *)semester;

/* Gets the related module timetable 
 information. */
- (NSDictionary *)timetableModule:(NSString *)courseID;

/* Gets the list of gradebook items 
 for the Module ID */
- (NSDictionary *)gradebookViewItems:(NSString *)courseID;

/* Gets the related Library E-reserve folders for the Module by CourseID. */
- (NSDictionary *)libEreserves:(NSString *)courseID withTitleOnly:(BOOL)title;

/* Gets the related Library E-reserve Files by Folder ID. */
- (NSDictionary *)libEreserveFiles:(NSString *)folderID;

/* Gets the related My Organizer IVLE Events for the indicated period for the user */
- (NSDictionary *)MyOrganizerIVLE:(NSString *)startDate withEndDate:(NSString *)endDate;

- (NSDictionary *)MyOrganizerAcadSemesterInfo:(NSString *)acadYear ForSem:(NSString *)semester;

- (NSDictionary *)CodeTableWeekTypes;

/*	Converts boolean to System boolean. YES => @"true", NO => @"false"*/
-(NSString*)booleanToSystemBoolean:(BOOL)boolean;
@end
