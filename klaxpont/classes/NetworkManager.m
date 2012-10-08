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

#import "RegisterRequest.h"
#import "DailymotionTokenRequest.h"


@interface NetworkManager()
{
    Video *_currentVideo;
    NSOperationQueue* networkQueue;
}

- (void) queueRequest:(NSMutableURLRequest*)request;
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

- (void) queueRequest:(NSMutableURLRequest*)request
{
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request  delegate:self];
    if (connection) {
        [connection setDelegateQueue:networkQueue];
        [connection start];
    }
}

#pragma mark - Reachability

- (BOOL) isNetworkAvailable
{
    Reachability *reachabilityForInternetConnection = [Reachability reachabilityForInternetConnection];
    if([reachabilityForInternetConnection currentReachabilityStatus] == NotReachable){
        NSLog(@"no internet connection");
        return NO;
    }
 
    return YES;
}

#pragma mark - Requests

#pragma mark Image

-(UIImage*) downloadImage:(NSString*)imageUrl
{
    NSData *data = nil;
    NSURL *url = [NSURL URLWithString:imageUrl];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    
    NSString *filePath =  [cachePath stringByAppendingPathComponent:[url lastPathComponent]];

    data = [NSData dataWithContentsOfFile:filePath];
    if(data){
        return [UIImage imageWithData:data];
    }else{
        data = [NSData dataWithContentsOfURL:url];
        if(data){
            NSError *error = nil;
            if(![data writeToFile:filePath options:NSDataWritingAtomic error:&error])
                NSLog(@"NetworkManager -  downloadImage: write error %@", error);
            return [UIImage imageWithData:data];
        }
    }
    

    return [UIImage imageNamed:DEFAULT_THUMBNAIL];
}

#pragma mark User

-(void) register
{
    if(![self isNetworkAvailable]) return;
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:SERVER_URL_FOR(USER_PATH)]];
//    [request setHTTPMethod:@"POST"];
//   
//    NSData *data = [[NSString stringWithFormat:@"facebook_id=%@", [UserHelper default].facebookId] dataUsingEncoding:NSUTF8StringEncoding];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//
//    [request setHTTPBody:data];
    RegisterRequest *request = RegisterRequest.new;
    [self queueRequest:request];
}

#pragma mark Dailymotion

- (void) requestDailymotionToken
{
    if(![self isNetworkAvailable]) return;

    DailymotionTokenRequest *request = DailymotionTokenRequest.new;
    [self queueRequest:request];
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
    if(error){

        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *errorResponse = @{@"code":@0, @"message":[error localizedDescription]};
            [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_NOTIFICATION object:nil userInfo:errorResponse];
           
        
        });
        return nil;
    }
    if(response){
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if(error){
           dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *errorResponse = @{@"code":@0, @"message":[error localizedDescription]};
                [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_NOTIFICATION object:nil userInfo:errorResponse];
                
                
            });

            return nil;
        }
        
        NSMutableArray *videosList = NSMutableArray.new;
        for (NSDictionary *video in [result objectForKey:SERVER_JSON_RESPONSE]) {
            NSMutableDictionary *infos = [[NSMutableDictionary alloc] initWithDictionary:video];
            UIImage *image = [self downloadThumbnailFor:[video objectForKey:@"thumbnail_url"]];

            
            [infos setObject:image forKey:@"thumbnail"];
            [videosList addObject:infos];
        }
        return videosList;
    }
    return nil;
}
- (UIImage*)downloadThumbnailFor:(NSString*)thumbnailUrl{
        __block UIImage *image = nil;

        if(thumbnailUrl != [NSNull null])
        {
            // TODO make it dispatch
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                image = [[NetworkManager sharedManager] downloadImage:thumbnailUrl];
            //});

            return image;
        }else
           return [UIImage imageNamed:DEFAULT_THUMBNAIL];


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

    NSLog(@"uploadVideo session: %@",session);
    
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

-(void) handleDailymotionTokenResponse:(NSDictionary*) data
{
    NSLog(@"handleDailymotionTokenResponse %@", data);
    [APP_DELEGATE setDailymotionSession:data];

    NSNumber *timeout = [[APP_DELEGATE dailymotionSession] objectForKey:@"expires_in"];
    if (timeout) {
        //scheduling request for refreshToken to our server
        [NSTimer scheduledTimerWithTimeInterval:[timeout doubleValue] target:self selector:@selector(requestDailymotionToken) userInfo:nil repeats:NO];
    }
}


-(void) handleUserRegistrationResponse:(NSDictionary*) data
{
    NSLog(@"handleUserRegistrationResponse %@", data);
    [[UserHelper default] setKlaxpontId:[data objectForKey:@"user_id"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_REGISTERED_NOTIFICATION object:nil];
}

-(void) handlePublishVideoResponse:(NSDictionary*)data
{
    NSLog(@"handlePublishVideoResponse %@", data);

     

    [_currentVideo setVideoId:[data objectForKey:@"id"]];
    [DatabaseHelper saveContext];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:INFO_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[error localizedDescription], @"error", nil]];

}

#pragma mark - Delegates

#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int responseStatusCode = [httpResponse statusCode];
    NSLog(@"request status code %d", responseStatusCode);
    if (responseStatusCode >= 400) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_NOTIFICATION_WITH_ON_COMPLETE_BLOCK object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Error with server", @"error", nil]];
        [connection cancel];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError* error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    if(error){
        // handle parsing error
        [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_NOTIFICATION object:nil userInfo:@{@"message": [error localizedDescription]}];
        NSLog(@"error data from klaxpont %@",error );
    }else{
        NSLog(@"didReceiveData: json parsed %@", result);
        NSURLRequest *request = connection.originalRequest;
        if ([request respondsToSelector:@selector(processDataResponse:)]) {
            [request performSelector:@selector(processDataResponse:) withObject:result];
            return;
        }
    }
    
//    NSString *url = [connection.originalRequest.URL absoluteString];
//
//    NSLog(@"didReceiveData: data from klaxpont %@", data );
//    NSError* error;
//    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
//    
//    if(error){
//        // handle parsing error
//        [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_NOTIFICATION object:nil userInfo:@{@"message": [error localizedDescription]}];
//        NSLog(@"error data from klaxpont %@",error );
//    }else{
//        NSLog(@"didReceiveData: json parsed %@", result);
//
//        // handle error from server
//        NSDictionary *errorResponse = [result objectForKey:SERVER_JSON_ERROR];
//        if (errorResponse) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_NOTIFICATION object:self userInfo:errorResponse];
//            return;
//        }
//        
//        NSDictionary *dataResponse = [result objectForKey:SERVER_JSON_RESPONSE];
//        // switch
//        if([url hasSuffix:VIDEO_PATH] && [[connection.originalRequest HTTPMethod] isEqualToString:@"POST"]){
//            [self handlePublishVideoResponse:dataResponse];
//        }
//        else if([url hasSuffix:DAILYMOTION_API_TOKEN_PATH]){
//            [self handleDailymotionTokenResponse:dataResponse];
//        }
//        else if([url hasSuffix:USER_PATH]){
//            /////////////////////register
//            [self handleUserRegistrationResponse:dataResponse];
//        }
//    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   NSString *url = [connection.originalRequest.URL absoluteString];
    NSLog(@"Error %@ : %@",url, error );
    [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_NOTIFICATION object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[error localizedDescription], @"error", nil]];
    [connection cancel];
}

#pragma mark - Dailymotion delegate methods

- (void)dailymotion:(Dailymotion *)dailymotion didReturnResult:(id)result userInfo:(NSDictionary *)userInfo{
    NSLog(@"videos %@",result);
    NSDictionary *dictionnary = (NSDictionary*)result;
    [_currentVideo setDailymotionVideoId:[dictionnary objectForKey:@"id"]];
    [DatabaseHelper saveContext];
//    [[NSNotificationCenter defaultCenter] postNotificationName:INFO_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[error localizedDescription], @"error", nil]];
    
    [self publishVideo:_currentVideo];
}


- (void)dailymotion:(Dailymotion *)dailymotion didReturnError:(NSError *)error userInfo:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_NOTIFICATION_WITH_ON_COMPLETE_BLOCK object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[error localizedDescription], @"message", nil]];
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
