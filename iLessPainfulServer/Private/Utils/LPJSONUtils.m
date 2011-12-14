//
//  LPJSONUtils.m
//  iLessPainfulServer
//
//  Created by Karl Krukow on 11/08/11.
//  Copyright 2011 Trifork. All rights reserved.
//

#import "LPJSONUtils.h"
#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"
#import "DDLog.h"
static const int ddLogLevel = LOG_LEVEL_INFO;

@implementation LPJSONUtils

+ (NSString*) serializeDictionary:(NSDictionary*) dictionary {
    CJSONSerializer* s = [CJSONSerializer serializer];
    NSError* error = nil;
    NSData* d = [s serializeDictionary:dictionary error:&error];
    if (error) {
        DDLogError(@"Unable to serialize dictionary (%@), %@",error,dictionary);
    }
    NSString* res = [[NSString alloc]  initWithBytes:[d bytes]
                              length:[d length] encoding: NSUTF8StringEncoding];
    return [res autorelease];
}
+ (NSDictionary*) deserializeDictionary:(NSString*) string {
    CJSONDeserializer* ds = [CJSONDeserializer deserializer];
    NSError* error = nil;
    NSDictionary* res = [ds deserializeAsDictionary:[string dataUsingEncoding:NSUTF8StringEncoding]error:&error];
    if (error) {
        DDLogError(@"Unable to deserialize  %@",string);
    }
    return res;
}

+ (NSString*) serializeArray:(NSArray*) array {
    CJSONSerializer* s = [CJSONSerializer serializer];
    NSError* error = nil;
    NSData* d = [s serializeArray:array error:&error];
    if (error) {
        DDLogError(@"Unable to serialize arrayy (%@), %@",error,array);
    }
    NSString* res = [[NSString alloc]  initWithBytes:[d bytes]
                                              length:[d length] encoding: NSUTF8StringEncoding];
    return [res autorelease];
}
+ (NSArray*) deserializeArray:(NSString*) string {
    CJSONDeserializer* ds = [CJSONDeserializer deserializer];
    NSError* error = nil;
    NSArray* res = [ds deserializeAsArray:[string dataUsingEncoding:NSUTF8StringEncoding] error:&error];
    if (error) {
        DDLogError(@"Unable to deserialize  %@",string);
    }
    return res;
}


@end
