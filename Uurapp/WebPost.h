//
//  WebPost.h
//  Uurapp
//
//  Created by Code54 on 3/7/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebPost : NSObject {
   @private  NSMutableDictionary *dict;
}

@property (readwrite) NSString *requestString;

- (NSString*) EncodeURL: (NSString *)string;
- (void) AddKey: (NSString *)key AddValue:(NSString *)value;
- (NSMutableURLRequest *) GetURLRequest;

@end
