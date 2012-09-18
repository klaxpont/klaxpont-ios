//
//  NetworkManager.m
//  klaxpont
//
//  Created by François Benaiteau on 8/28/12.
//
//

#import "NetworkManager.h"

#import "UserHelper.h"
#import "Video.h"
#import "Dailymotion.h"
#import "DatabaseHelper.h"
#import "AppDelegate.h"
#import "Reachability.h"

@interface NetworkManager()
{
    Video *_currentVideo;
}
@end

@implementation NetworkManager

static NSString *knetworkManager = @"networkManager";

#pragma mark - Initialization

+(NetworkManager *) sharedManager {
    static NetworkManager *manager = nil;
    
    if (manager == nil) {
        manager = [[NetworkManager alloc] init];
    }
    
    return manager;
}

-(id)init
{
    if(self = [super init])
    {
    
    }
    return self;
}
#pragma mark - Reachability

- (BOOL) isNetworkAvailable
{
    Reachability *reachabilityForInternetConnection = [Reachability reachabilityForInternetConnection];
    if([reachabilityForInternetConnection currentReachabilityStatus] == NotReachable){
        NSLog(@"no connection");
        return NO;
    }
    return YES;
}

#pragma mark - Requests

#pragma mark User

-(void) register
{
    if(![self isNetworkAvailable])
        return;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:SERVER_URL_FOR(USER_PATH)]];
    [request setHTTPMethod:@"POST"];
   
    NSData *data = [[NSString stringWithFormat:@"facebook_id=%@", [UserHelper default].facebookId] dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    [request setHTTPBody:data];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request  delegate:self];
    if (connection) {
        [connection start];
    }
}

#pragma mark Dailymotion

- (void) requestDailymotionToken{
    if(![self isNetworkAvailable])
        return;

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:SERVER_URL_FOR(DAILYMOTION_API_TOKEN_PATH)]];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        [connection start];
    }
}


#pragma mark Video
//TODO: this is shit but temporary, to refactor
-(NSArray*) retrieveVideos
{
    if(![self isNetworkAvailable])
        return nil;

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:SERVER_URL_FOR(VIDEO_PATH)]];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(error)
        return nil;
    if(response){
        NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if(error)
            return nil;
        return result;
    }
    return nil;
}

-(void) uploadVideo:(Video*)video
{
    if(![self isNetworkAvailable])
        return;

    NSLog(@"uploading video to dailymotion");
    NSDictionary *errorResponse = @{@"code":@0, @"message":NSLocalizedString(@"VIDEO_UPLOADING", nil)};
    [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_NOTIFICATION object:nil userInfo:errorResponse];

    _currentVideo = video;
    // TODO test video has video_dailymotion id ?

    //////////////upload to dailymotion
    Dailymotion *dailymotion = [[Dailymotion alloc] init];
    //todo handle missing session
    NSDictionary *session = [APP_DELEGATE dailymotionSession];
    [dailymotion setSession:session];

    NSLog(@"uploadVideo session: %@",[dailymotion readSession]);
    
    //upload
    [dailymotion uploadFile:[video localPath] delegate:self];

    //////////////upload video infos to our server
}

-(void) publishVideo:(Video*)video
{
    if(![self isNetworkAvailable])
        return;

    NSDictionary *errorResponse = @{@"code":@0, @"message":NSLocalizedString(@"VIDEO_PUBLISHING", nil)};
    [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_NOTIFICATION object:nil userInfo:errorResponse];
    NSLog(@"publishing video to our Server");

    _currentVideo = video;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:SERVER_URL_FOR(VIDEO_PATH)]];
      
    NSData *data = [[NSString stringWithFormat:@"user_id=%d&video_id=%@", [[UserHelper default].klaxpontId intValue], video.dailymotionVideoId] dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        [connection start];
    }
}

#pragma mark - Handling Responses

-(void) handleDailymotionTokenResponse:(NSData*) data
{
    if (data) {
        NSError* error;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error != nil) {
            NSLog(@"handleDailymotionTokenResponse: error parsing response: %@", [error localizedDescription]);
            //todo handle error
            NSDictionary *errorResponse = @{@"code":@0, @"message":[error localizedDescription]};
            [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_NOTIFICATION object:nil userInfo:errorResponse];
            return;
        }
        NSDictionary *errorResponse = [response objectForKey:@"error"];
        if (errorResponse) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_NOTIFICATION object:self userInfo:errorResponse];
            return;
        }
        
        NSDictionary *session = [response objectForKey:@"response"];
        NSLog(@"dailymotion session %@", session);
        [APP_DELEGATE setDailymotionSession:session];
        NSNumber *timeout = [[APP_DELEGATE dailymotionSession] objectForKey:@"expires_in"];
        NSLog(@"set dailymotion session %@", [APP_DELEGATE dailymotionSession]);
        
        if (timeout) {
            //scheduling request for refreshToken to our server
            [NSTimer scheduledTimerWithTimeInterval:[timeout doubleValue] target:self selector:@selector(requestDailymotionToken) userInfo:nil repeats:NO];
        }
    }
}


-(void) handleUserRegistrationResponse:(NSData*) data
{
    if (data) {
        NSLog(@"data from klaxpont %@", data );
        NSError* error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if(error)
            NSLog(@"error data from klaxpont %@",error );
        else{
            NSLog(@"data from klaxpont %@",result );
            [[UserHelper default] setKlaxpontId:[result objectForKey:@"user_id"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"user.registered" object:nil];
        }
    }
}

-(void) handlePublishVideoResponse:(NSData*)data
{
    NSLog(@"response %@", data);
    NSError* error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"data from klaxpont after publish video; data: %@", result );
}

#pragma mark - Delegates

#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int responseStatusCode = [httpResponse statusCode];
    NSLog(@"request status code %d", responseStatusCode);
//    if (responseStatusCode >= 400) {
//        [connection cancel];
//    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    NSString *relativePath = [[[connection currentRequest] URL] relativePath];
    NSString *url = [connection.originalRequest.URL absoluteString];

    NSLog(@"data from klaxpont %@", data );
    NSError* error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(error)
        NSLog(@"error data from klaxpont %@",error );
    else{
        NSLog(@"data from klaxpont %@",result );
        [[UserHelper default] setKlaxpontId:[result objectForKey:@"user_id"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"user.registered" object:nil];
    }



    if([url hasSuffix:VIDEO_PATH] && [[connection.originalRequest HTTPMethod] isEqualToString:@"POST"]){
        [self handlePublishVideoResponse:data];
    }
    else if([url hasSuffix:DAILYMOTION_API_TOKEN_PATH]){
        [self handleDailymotionTokenResponse:data];
    }
    else if([url hasSuffix:USER_PATH]){
        /////////////////////register
        [self handleUserRegistrationResponse:data];
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error from connection %@",error );
    [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_NOTIFICATION object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[error localizedDescription], @"error", nil]];

//    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
    [connection cancel];
}

#pragma mark - Dailymotion delegate methods

- (void)dailymotion:(Dailymotion *)dailymotion didReturnResult:(id)result userInfo:(NSDictionary *)userInfo{
    
    NSLog(@"videos %@",result);
    NSDictionary *dictionnary = (NSDictionary*)result;
    [_currentVideo setDailymotionVideoId:[dictionnary objectForKey:@"id"]];
    [DatabaseHelper saveContext];
    [self publishVideo:_currentVideo];
}


- (void)dailymotion:(Dailymotion *)dailymotion didReturnError:(NSError *)error userInfo:(NSDictionary *)userInfo{
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Error from dailymotion"
                                                   message:[error localizedDescription]
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [alert show];
}


- (void)dailymotion:(Dailymotion *)dailymotion didUploadFileAtURL:(NSString *)URL;
{
    NSDictionary *videoArguments = [NSDictionary dictionaryWithObjectsAndKeys:URL,@"url",
                                    _currentVideo.title,@"title",
                                    //@"fun", @"channel", //@todo: chcek that channel is required move it to server logic
                                    nil];
    [dailymotion request:@"POST /me/videos"
           withArguments:videoArguments
                delegate:self];
}


@end
