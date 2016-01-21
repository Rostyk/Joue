//
//  SDAuth.m
//  

#import "SDAuth.h"
//#import "SDResult+Constants.h"
#import "NSString+SDAdditions.h"

#import "SDInternetConnection.h"
#import "SDResult.h"

#import "SDUserSettings.h"
#import "SDKeyStorage.h"

const NSTimeInterval        MLAuthTimeoutInteraval = 60.0f;

const float                 MLAuthSimulationMinDelay = 0.0;
const float                 MLAuthSimulationMaxDelay = 1.0;
const float                 MLAuthSimulationFailProbability = 0.0;

static NSString * const SDNullJsonParam                 = @"null";

#pragma mark - Helper functions

static float frand() // returns float random value in the range [0..1]
{
    return (arc4random() % 100001) / 100000.0;
}


const NSString *SDResponseData = @"data";
const NSString *SDAccessToken  = @"access_token";
const NSString *SDUserId       = @"id";

#pragma mark - MLAuth

@interface SDAuth ()
{
    NSString *serviceURL_;
    NSString *securityToken_;
    NSDate *tokenValidTill_;
    NSString *userName_;
    NSNumber *userId_;
    NSString *passwordHash_;
    NSURLSession *session_;
    NSURLSessionDataTask *authRequest_;
}

@property (nonatomic, strong) NSString *passwordHash;

- (void)simulateAuthenticateWithUserName:(NSString *)userName password:(NSString *)password;

@end


@implementation SDAuth

@synthesize serviceURL = serviceURL_;
@synthesize delegate = delegate_;
@synthesize securityToken = securityToken_;
@synthesize tokenValidTill = tokenValidTill_;
@synthesize userName = userName_;
@synthesize userId = userId_;
@synthesize passwordHash = passwordHash_;

#pragma mark - Memory management

- (id)initWithServiceURL:(NSString *)serviceURL delegate:(id<SDAuthDelegate>)delegate
{
    self = [super init];
    
    if (self)
    {
        self.serviceURL = serviceURL;
        self.delegate = delegate;
        
        // restore the info
        if ([SDUserSettings accessToken].length > 0 && [SDUserSettings userId].integerValue != 0 && [SDKeyStorage passwordWithUsername:[SDUserSettings userName]].length > 0)
        {
            userName_ = [SDUserSettings userName];
            passwordHash_ = [SDKeyStorage passwordWithUsername:userName_];
            securityToken_ = [SDUserSettings accessToken];
            userId_ = [SDUserSettings userId];
        }
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        session_ = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        
        serviceURL_ = [SDUserSettings serviceURL];
    }
    
    return self;
}

- (id)initWithServiceURL:(NSString *)serviceURL
{
    return [self initWithServiceURL:serviceURL delegate:nil];
}

- (void)dealloc
{
    [authRequest_ cancel];
}

#pragma mark - this shouldn't be here

#pragma mark - Common request processing method

- (void)logNetworkRequest:(NSURLRequest *)request
{
    NSMutableString *headerFields = [NSMutableString string];
    
    for (NSString *field in [request.allHTTPHeaderFields allKeys])
    {
        [headerFields appendFormat:@"    %@: %@\n", field, [request.allHTTPHeaderFields valueForKey:field]];
    }
    
    NSString *body = request.HTTPBody.length > 0 ? (request.HTTPBody.length > 2048 ? [NSString stringWithFormat:@"    <%lu bytes>", (unsigned long)request.HTTPBody.length]
                                                    : [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]) : @"    <empty>";
    
    NSLog(@"\n----- [NETWORK REQUEST] -----\n  URL: %@\n  METHOD: %@\n  HEADER FIELDS\n%@  BODY\n%@\n-----------------------------\n",
          request.URL,
          request.HTTPMethod,
          headerFields,
          body);
}

- (void)logNetworkResponse:(NSHTTPURLResponse *)response error:(NSError *)error data:(NSData *)data
{
    if (error == nil)
    {
        /*NSLog(@"\n----- [NETWORK RESPONSE] -----\n  URL: %@\n  STATUS CODE: %li\n HEADER FIELDS\n%@  BODY\n    %@\n------------------------------\n",
              response.URL,
              (long)response.statusCode,
              response.allHeaderFields,
              data.length > 0 ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"<empty>");*/
    }
    else
    {
        NSLog(@"\n----- [NETWORK RESPONSE] -----\n  ERROR: %@\n", [error localizedDescription]);
    }
}

#pragma mark - Properties

- (void)authenticateWithUserName:(NSString *)userName
                    passwordHash:(NSString *)passwordHash
{
    if ([self isAuthenticating])
    {
        return;
    }
//    else if ([SDUserSettings accessToken].length > 0 && [SDUserSettings userId].integerValue != 0)
//    {
//        userName_ = userName;
//        passwordHash_ = passwordHash;
//        securityToken_ = [SDUserSettings accessToken];
//        userId_ = [SDUserSettings userId];
//        
//        [delegate_ didSucceedAuthentication:self keepAlive:YES];
//    }
    else
    {
//        NSURL *url = [NSURL URLWithString:serviceURL_];
//        NSString *host = [url host];
        
        if ([SDInternetConnection networkStatus] != NotReachable)
        {
            if (serviceURL_ != nil)
            {
                userName_ = userName;
                self.passwordHash = passwordHash_;
                
//                // ASIRequest
//                __block ASIHTTPRequest *authRequest = [ASIHTTPRequest requestWithURL:
//                                                       [NSURL URLWithString:[NSString stringWithFormat:@"%@users/create", serviceURL_]]];
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@account/login", serviceURL_]]];
                
                request.HTTPMethod = @"POST";
                request.timeoutInterval = MLAuthTimeoutInteraval;
                
                // Setting Body
                NSString *postBody = [NSString stringWithFormat:@"email=%@&password=%@", [userName URLEncodedString], passwordHash];
                
                [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
                
                [self logNetworkRequest:request];
                
                authRequest_ = [session_ dataTaskWithRequest:request
                                                            completionHandler:^(NSData *data,
                                                                                NSURLResponse *response,
                                                                                NSError *error) {
                                                                if (!error)
                                                                {
                                                                    [self logNetworkResponse:(NSHTTPURLResponse *)response error:error data:data];
                                                                    
                                                                    NSError *error = nil;
                                                                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                             options:NSJSONReadingMutableContainers
                                                                                                                               error:&error];
                                                                    
                                                                    if (!error)
                                                                    {
                                                                        NSDictionary *responseDictionary = [jsonDict objectForKey:SDResponseData];
                                                                        
                                                                        if ([responseDictionary isKindOfClass:NSDictionary.class] && [responseDictionary objectForKey:SDAccessToken] != nil)
                                                                        {
                                                                            NSLog(@"[AUTH]: first stage succeeded");
                                                                            
                                                                            securityToken_ = [responseDictionary objectForKey:SDAccessToken];
                                                                            [SDUserSettings setAccessToken:securityToken_];
//                                                                            userId_ = [responseDictionary objectForKey:SDUserId];
//                                                                            [SDUserSettings setUserId:userId_];
                                                                            
                                                                            [delegate_ didSucceedAuthentication:self keepAlive:NO];
                                                                        }
                                                                        else
                                                                        {
                                                                            NSLog(@"[AUTH]: login failed (invalid token data)");
                                                                            [delegate_ authentication:self didFailWithError:[SDResult errorWithCode:((NSHTTPURLResponse *)response).statusCode]];
                                                                            
                                                                            [self drop];
                                                                        }
                                                                    }
                                                                    else
                                                                    {
                                                                        [delegate_ authentication:self
                                                                                 didFailWithError:[SDResult errorWithCode:0
                                                                                                                  message:[error localizedDescription]]];
                                                                        
                                                                        [self drop];
                                                                    }
                                                                }
                                                            }];
                
                [authRequest_ resume];
                
//                authRequest.requestMethod = @"POST";
//                authRequest.timeOutSeconds = MLAuthTimeoutInteraval;
//                
//                //            [authRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
//                //            [authRequest addRequestHeader:@"Expect" value:@"100-continue"];
//                //            [authRequest addRequestHeader:@"Connection" value:@"Keep-Alive"];
//                
//                NSMutableString *postString = [NSMutableString stringWithFormat:@"email=%@&password=%@&promo_code=%@",
//                                               [userName URLEncodedString], [passwordHash URLEncodedString],
//                                               promoCode.length > 0 ? promoCode : SDNullJsonParam];
//                
//                if ([SDAppDelegate rootViewController].deviceToken.length > 0)
//                {
//                    [postString appendFormat:@"&device_token=%@", [SDAppDelegate rootViewController].deviceToken];
//                }
//                
//                [authRequest appendPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
//                
//                [authRequest setCompletionBlock:^
//                 {
//                     [authRequest logNetworkResponse];
//                     
//                     NSError *error = nil;
//                     NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:authRequest.responseData
//                                                                              options:NSJSONReadingMutableContainers error:&error];
//                     
//                     NSDictionary *responseDictionary = [jsonDict objectForKey:SDResponseData];
//                     
//                     if ([responseDictionary objectForKey:SDAccessToken] != nil)
//                     {
//                         NSLog(@"[AUTH]: first stage succeeded");
//                         
//                         securityToken_ = [responseDictionary objectForKey:SDAccessToken];
//                         [SDUserSettings setAccessToken:securityToken_];
//                         userId_ = [responseDictionary objectForKey:SDUserId];
//                         [SDUserSettings setUserId:userId_];
//                         
//                         [delegate_ didSucceedAuthentication:self keepAlive:NO];
//                     }
//                     else
//                     {
//                         NSLog(@"[AUTH]: login failed (invalid token data)");
//                         [delegate_ authentication:self didFailWithError:[SDResult errorWithCode:0]];
//                         
//                         [self drop];
//                     }
//                 }];
//                
//                [authRequest setFailedBlock:^
//                 {
//                     NSLog(@"[AUTH]: HTTP request failed");
//                     
//                     [authRequest logNetworkResponse];
//                     
//                     [delegate_ authentication:self
//                              didFailWithError:[SDResult errorWithCode:0
//                                                               message:[authRequest.error localizedDescription]]];
//                     
//                     [self drop];
//                 }];
//                
//                authRequest_ = authRequest;
//                
//                NSLog(@"[AUTH]: Sending request...");
//                [authRequest_ logNetworkRequest];
//                
//                [authRequest_ startAsynchronous];
            }
            else
            {
                [self simulateAuthenticateWithUserName:userName password:passwordHash];
            }
        }
        else
        {
            NSLog(@"[AUTH]: No Internet connection!");
            [delegate_ authentication:self
                     didFailWithError:[SDResult errorWithCode:0]];
        }
    }
}

- (void)drop
{
    @synchronized (self)
    {
        [authRequest_ cancel];
        
        authRequest_ = nil;
        securityToken_ = nil;
        userName_ = nil;
        userId_ = nil;
        passwordHash_ = nil;
    }
}

- (void)logout
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@auth?token=%@", serviceURL_, securityToken_]]];
    
    request.HTTPMethod = @"DELETE";
    request.timeoutInterval = MLAuthTimeoutInteraval;
    
    [self logNetworkRequest:request];
    
    authRequest_ = [session_ dataTaskWithRequest:request
                               completionHandler:^(NSData *data,
                                                   NSURLResponse *response,
                                                   NSError *error) {
                                   if (!error)
                                   {
                                       [self logNetworkResponse:(NSHTTPURLResponse *)response error:error data:data];
                                       
                                       NSError *error = nil;
                                       NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                                                                options:NSJSONReadingMutableContainers
                                                                                                  error:&error];
                                       
                                       if (!error)
                                       {
                                       }
                                   }
                               }];
    
    [authRequest_ resume];
}

- (void)refreshToken
{
    [self authenticateWithUserName:userName_ passwordHash:passwordHash_];
}

- (BOOL)isAuthenticating
{
    return authRequest_ != nil;
}

- (BOOL)isAuthenticated
{
    return userName_ != nil;
}

/// SHA256
//+ (NSString *)hashWithPassword:(NSString *)password
//{
//    NSData *data = [password dataUsingEncoding:NSUnicodeStringEncoding];
//
//    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
//    CC_SHA256(((const char *)[data bytes]) + 2, (CC_LONG)data.length - 2, hash);
//
//    NSData *hashData = [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];
//    
//    return [hashData base64EncodedString];
//}

/// MD5
+ (NSString *)hashWithPassword:(NSString *)password
{
    // Create pointer to the string as UTF8
    const char *ptr = [password UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

@end
