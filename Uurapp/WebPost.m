//
//  Webost.m
//  Uurapp
//
//  Created by Code54 on 3/7/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import "WebPost.h"
#import "Constants.h"

@implementation WebPost


@synthesize requestString;

- (id)init
{
    self = [super init];
    if (self)
    {
        dict = [[NSMutableDictionary alloc] init];
        requestString = [[NSString alloc] init];
    }
    return self;
}

- (void) AddKey: (NSString *)key AddValue:(NSString *)value
{
    if (value.length > 0)
        [dict setObject:value forKey:key];
}


- (NSString*) EncodeURL: (NSString *)string
{
    NSString *newString =
        CFBridgingRelease(
                      CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (__bridge CFStringRef)string,
                                                              NULL,
                                                              CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
                                                              kCFStringEncodingUTF8));
    return newString;
}

- (void) SetRequestString
{
    //build request string
    requestString = @"";
    NSArray *keys = [dict allKeys];
    for (NSString *key in keys) {
        requestString = [requestString stringByAppendingFormat:@"&%@=%@",key, [self EncodeURL:[dict objectForKey:key]]];
	}
}

- (NSMutableURLRequest *) GetURLRequest
{
    [self SetRequestString];
    
    NSURL *url=[NSURL URLWithString:apiURL];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:url];
    NSData *myRequestData = [ NSData dataWithBytes: [ requestString UTF8String ] length: [ requestString length ] ];
    [URLRequest setHTTPMethod:@"POST"];
    [URLRequest setHTTPBody:myRequestData ];
    NSLog(@"WebPost GetURLRequest: %@",requestString);
    return URLRequest;    
}

@end
