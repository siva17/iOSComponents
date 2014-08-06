//
//  WebServiceClient.m
//  WebService
//
//  Created by Siva RamaKrishna Ravuri
//  Copyright (c) 2014 www.siva4u.com. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import <objc/runtime.h>
#import "WebServiceClient.h"
#import "DMBase.h"

@interface WebServiceClient ()
@property(nonatomic,assign) id delegate;
@property(nonatomic,retain) DownloadClient	*dcRequest;
@property(nonatomic,retain) DMWebservice	*wscDataModel;
@end

@implementation WebServiceClient

@synthesize delegate;
@synthesize dcRequest;
@synthesize wscDataModel;

#pragma mark - De-Allocs

-(void) releaseMem {
    RELEASE_MEM(dcRequest);
}

-(void) dealloc {
    [self releaseMem];
#if !(__has_feature(objc_arc))
    [super dealloc];
#endif
}

#pragma mark - Local APIs

-(void) callDelegateWithStatus:(WS_STATUS)status response:(DMWebservice *)response {
	if((self.delegate) && ([delegate respondsToSelector:@selector(webServiceClient: response:)])) {
		response.status = status;
		[delegate webServiceClient:self response:response];
	}
}
-(char *)getClassNameFromVar:(Ivar)var {
    if(var) {
        const char* className = ivar_getTypeEncoding(var);
        if(className) {
	        unsigned long strLen = strlen(className);
    	    if(strLen > 3) {
                unsigned long actualStrLen = strLen - 3;
        	    char* returnString = calloc(actualStrLen+1,1);
            	memcpy(returnString, className+2, actualStrLen);
	            returnString[actualStrLen] = 0;
    	        return returnString;
        	}
        }
    }
    return nil;
}

-(Ivar) getIvarWithName:(const char *)name fromIvars:(Ivar *)vars varCount:(unsigned int)varCount {
    unsigned int index = 0;
    while(index < varCount) {
        Ivar var = vars[index];
        const char* varName = ivar_getName(var);
        if(strcmp(name, varName) == 0) return var;
        index++;
    }
    return nil;
}

-(id)encodeFromDataModel:(id)dataModel {
    if(([dataModel isKindOfClass:[NSArray class]]) || ([dataModel isKindOfClass:[NSMutableArray class]])) {
        NSMutableArray *postArray = [[NSMutableArray alloc]init];
        if(postArray) {
            NSArray *arrayObject = (NSArray *)dataModel;
            for (id singleItem in arrayObject) {
                [postArray addObject:[self encodeFromDataModel:singleItem]];
            }
        }
        return postArray;
    } else {
        NSMutableDictionary *postData = [[NSMutableDictionary alloc]init];
        if([class_getSuperclass([dataModel class]) isSubclassOfClass:[DMBase class]]) {
            
            unsigned int varCount;
            unsigned int subVarCount;
            Ivar *vars = class_copyIvarList([dataModel class], &varCount);
            
            DMBase *dmBase = dataModel;
            NSArray *dmDefines = dmBase.dmDefines;
            
            int count = [dmDefines count];
            for (int i=0; i<count; i++) {
                NSDictionary *definesDict = [dmDefines objectAtIndex:i];
                NSString *name = [definesDict objectForKey:DM_DEFINE_DM_NAME];
                if(name) {
                    Ivar var = [self getIvarWithName:[name cStringUsingEncoding:NSUTF8StringEncoding] fromIvars:vars varCount:varCount];
                    if(var) {
                        char *className = [self getClassNameFromVar:var];
                        id object = object_getIvar(dataModel,var);
                        if(object) {
                            NSString *classNameNSStr = [NSString stringWithUTF8String:className];
                            if([classNameNSStr rangeOfString:@"Array"].location != NSNotFound) {
                                NSMutableArray *postArray = [[NSMutableArray alloc]init];
                                if(postArray) {
                                    NSArray *arrayObject = (NSArray *)object;
                                    for (id singleItem in arrayObject) {
                                        [postArray addObject:[self encodeFromDataModel:singleItem]];
                                    }
                                    [postData setObject:postArray forKey:[definesDict objectForKey:DM_DEFINE_MAPPING]];
                                }
                            } else {
                                Ivar *subVars = class_copyIvarList([objc_getClass(className) class], &subVarCount);
                                if(subVarCount > 0) {
                                    [postData setObject:[self encodeFromDataModel:object] forKey:[definesDict objectForKey:DM_DEFINE_MAPPING]];
                                } else {
                                    [postData setObject:object forKey:[definesDict objectForKey:DM_DEFINE_MAPPING]];
                                }
                                free(subVars);
                            }
                        }
                        free(className);
                    }
                }
            }
            free(vars);
        }
        return postData;
    }
    return nil;
}

-(void)decodeToDataModel:(id)dataModel jsonData:(id)jsonData {
    if([class_getSuperclass([dataModel class]) isSubclassOfClass:[DMBase class]]) {
        unsigned int varCount;
        Ivar *vars = class_copyIvarList([dataModel class], &varCount);
        
        DMBase *dmBase = dataModel;
        NSArray *dmDefines = dmBase.dmDefines;
        
        NSDictionary *inData = (NSDictionary *)jsonData;
        
        int count = [dmDefines count];
        for (int i=0; i<count; i++) {
            NSDictionary *definesDict = [dmDefines objectAtIndex:i];
            NSString *key = [definesDict objectForKey:DM_DEFINE_MAPPING];
            if(key) {
                id responseData = [inData objectForKey:key];
                if(responseData) {
                    NSString *name = [definesDict objectForKey:DM_DEFINE_DM_NAME];
                    if(name) {
                        Ivar var = [self getIvarWithName:[name cStringUsingEncoding:NSUTF8StringEncoding] fromIvars:vars varCount:varCount];
                        if(var) {
                            id returnObject;
                            if([responseData isKindOfClass:[NSDictionary class]]) {
                                char *className = [self getClassNameFromVar:var];
                                if(className) {
                                    NSString *classNameNSString = [NSString stringWithUTF8String:className];
                                    free(className);
                                    id returnObject = [[NSClassFromString(classNameNSString) alloc]init];
                                    [self decodeToDataModel:returnObject jsonData:responseData];
                                    responseData = returnObject;
                                }
                            } else if([responseData isKindOfClass:[NSArray class]]) {
                                NSString *classNameNSString = [definesDict objectForKey:DM_DEFINE_ARRAY_TYPE];
                                if(classNameNSString) {
                                    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
                                    NSArray *jsonArray = (NSArray *)responseData;
                                    for(id localJsonData in jsonArray) {
                                        id returnObject = [[NSClassFromString(classNameNSString) alloc]init];
                                        [self decodeToDataModel:returnObject jsonData:localJsonData];
                                        [returnArray addObject:returnObject];
                                    }
                                    responseData = returnArray;
                                }
                            } else {
                                returnObject = responseData;
                            }
                            object_setIvar(dataModel, var, responseData);
                        }
                    }
                }
            }
        }
        free(vars);
    }
}

-(void)validateAndUpdateHttpMethod {
    NSString *httpMethod = [wscDataModel.httpMethod uppercaseString];
    if(httpMethod == nil) httpMethod = HTTP_REQUEST_METHOD_GET;
    wscDataModel.httpMethod = httpMethod;
}

#pragma mark - Public APIs

-(id)initWithDelegate:(id)wscDelegate {
    self = [super init];
    if (self) {
        // Custom initialization
        [self releaseMem];
        self.delegate = wscDelegate;
    }
    return self;
}

-(void)sendRequest:(DMWebservice *)dataModel {
    wscDataModel = dataModel;
    dcRequest = [[DownloadClient alloc]initWithDelegate:self];
    if (dcRequest) {
        [dcRequest setHeaderOptions:wscDataModel.httpHeaders];
        [self validateAndUpdateHttpMethod];
        NSData *postData = nil;
        if(![wscDataModel.httpMethod isEqualToString:HTTP_REQUEST_METHOD_GET]) {
            id postDataDefinition = [self encodeFromDataModel:wscDataModel.requestDM];
            if(postDataDefinition) {
                NSError *error;
                postData = [NSJSONSerialization dataWithJSONObject:postDataDefinition
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
                if(error) AppLog(APP_LOG_ERR,@"Error:%@\n",[error localizedDescription]);
            }
        }
        [dcRequest startDownloadWithUrl:wscDataModel.url httpMethod:wscDataModel.httpMethod data:postData];
    } else {
        wscDataModel.errorMsg = WS_RSP_MSG_CONNECTION_ERROR;
        [self callDelegateWithStatus:WS_STATUS_FAIL response:wscDataModel];
    }
}

- (void) cancelRequest {
    RELEASE_MEM(dcRequest);
    NSLog(@"Request cancelled!!");
}


#pragma - Download Client delegate methods

-(void)downloadClient:(DownloadClient *)downloadClient data:(NSData *)data dataModel:(DownloadClientDM *)dataModel {
    EnumDownloadClientStatus status = dataModel.status;
    if (status == EnumDownloadClientStatusCompleted) {
        wscDataModel.responseCode = dataModel.statusCode;
        if (data) {
            NSError *error;
            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:&error];
            if(error) AppLog(APP_LOG_ERR,@"Error:%@\n",[error localizedDescription]);
            if(jsonData) {
                [self decodeToDataModel:wscDataModel.responseDM jsonData:jsonData];
            }
        }
        [self callDelegateWithStatus:WS_STATUS_SUCCESS response:wscDataModel];
    } else if(status == EnumDownloadClientStatusFail) {
        [self callDelegateWithStatus:WS_STATUS_FAIL response:nil];
    } else if(status == EnumDownloadClientStatusTimeOut) {
        [self callDelegateWithStatus:WS_STATUS_TIMEOUT response:nil];
    } else if(status == EnumDownloadClientStatusNoNetwork) {
        [self callDelegateWithStatus:WS_STATUS_NO_NETWORK response:nil];
    }
}

@end
