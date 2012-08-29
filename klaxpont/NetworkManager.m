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

#pragma mark - Requests

#pragma mark User

-(void) register
{
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
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:SERVER_URL_FOR(DAILYMOTION_API_TOKEN_PATH)]];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        [connection start];
    }
}


#pragma mark Video

-(void) uploadVideo:(Video*)video
{
    NSLog(@"uploading video to dailymotion");
    _currentVideo = video;
    // TODO test video has video_dailymotion id ?
    
    //////////////upload to dailymotion
    Dailymotion *dailymotion = [[Dailymotion alloc] init];
    //todo handle missing session
    [dailymotion setSession:[APP_DELEGATE dailymotionSession]];
    
    //upload
    [dailymotion uploadFile:[video localPath] delegate:self];

    //////////////upload video infos to our server
}

-(void) publishVideo:(Video*)video
{
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
        //todo handle error
        [APP_DELEGATE setDailymotionSession:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]];
        NSNumber *timeout = [[APP_DELEGATE dailymotionSession] objectForKey:@"expires_in"];
        
        if (timeout) {
            //scheduling request for refreshToken to our server
            [NSTimer scheduledTimerWithTimeInterval:[timeout doubleValue] target:self selector:@selector(requestDailymotionToken) userInfo:nil repeats:NO];
        }
    }
}


-(void) handleVideosResponse:(NSData*) data
{
    NSLog(@"response %@", data);
    NSError* error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"data from klaxpont videos; data: %@", result );

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

    if([url hasSuffix:VIDEO_PATH]){
        if([[connection.originalRequest HTTPMethod] isEqualToString:@"POST"])
            [self handlePublishVideoResponse:data];
        else
            [self handleVideosResponse:data];
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
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
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
