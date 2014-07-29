//
//  WSHomeList.m
//  WebServiceInterface
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

#import "WSHomeList.h"
#import "DMHomeListReq.h"
#import "DMHomeList.h"
#import "DMHomeListItem.h"

#define REQ_LOCATION		@"requestName"
#define REQ_KEYWORD			@"searchName"

#define RSP_LIST_ITEMS		@"list"
#define RSP_LIST_ITEM_ID	@"ID"
#define RSP_LIST_ITEM_NAME	@"Name"
#define RSP_LIST_ITEM_DESC	@"Description"
#define RSP_STATUS			@"status"
#define RSP_ERROR_MSG		@"error_msg"

@implementation WSHomeList

#pragma mark - Override API

-(id) decodeRequestResponse:(id)response status:(WSI_STATUS)status {
    
    id successResponse = [self getResponseData:response];
    
    if(status == WSI_STATUS_SUCCESS) {
#if (__has_feature(objc_arc))
        DMHomeList *homeListResponse    = [[DMHomeList alloc] init];
#else
        DMHomeList *homeListResponse    = [[[DMHomeList alloc] init]autorelease];
#endif
        NSString *tmp;
        NSDictionary *rspDictionary = successResponse;
        if(rspDictionary) {
            
            NSArray *rspArray = [rspDictionary objectForKey:RSP_LIST_ITEMS];
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            if (tempArray) {
                for (NSDictionary *rspDictionary  in rspArray) {
                    
                    DMHomeListItem *singleItem = [[DMHomeListItem alloc]init];
                    
                    tmp = [rspDictionary objectForKey:RSP_LIST_ITEM_ID];
                    if((tmp) && (tmp != (NSString *)[NSNull null])) singleItem.listItemID = [NSString stringWithString:tmp];
                    
                    tmp = [rspDictionary objectForKey:RSP_LIST_ITEM_NAME];
                    if((tmp) && (tmp != (NSString *)[NSNull null])) singleItem.listItemName = [NSString stringWithString:tmp];
                    
                    tmp = [rspDictionary objectForKey:RSP_LIST_ITEM_DESC];
                    if((tmp) && (tmp != (NSString *)[NSNull null])) singleItem.listItemDescription = [NSString stringWithString:tmp];
                    
                    [tempArray addObject:singleItem];
                    RELEASE_MEM(singleItem);
                }
                RELEASE_MEM(homeListResponse.homeList);
                homeListResponse.homeList = tempArray;
                RELEASE_MEM(tempArray);
            }
            
            homeListResponse.status		= [WebServiceBase getBooleanStatusFromResponse:[rspDictionary objectForKey:RSP_STATUS]];
            homeListResponse.errorMsg	= NULL;
        } else {
            homeListResponse.status		= false;
            homeListResponse.errorMsg	= @"List not found";
        }
        
        successResponse = homeListResponse;
    }
    
    return [super decodeRequestResponse:successResponse status:status];
}

-(id) encodeRequestParams :(id)params {
    /*
     * All the parameters for belows can be set
     * 1. WSI_KEY_WSC_URL           @"url"          - Mandatory
     * 2. WSI_KEY_WSC_HTTP_METHOD   @"httpMethod"   - Optional, default is GET
     * 3. WSI_KEY_WSC_POST_DATA     @"postData"     - Optional, default is nil
     * 4. WSI_KEY_WSC_HEADERS       @"headers"      - Optional, default headers will be set
     */
#if (__has_feature(objc_arc))
    NSMutableDictionary *wsParams = [[NSMutableDictionary alloc]initWithDictionary:params];
#else
    NSMutableDictionary *wsParams = [[[NSMutableDictionary alloc]initWithDictionary:params]autorelease];
#endif
    
    // Step 1 - Setting of URL
    NSString *url = NULL;
    DMHomeListReq *homeListDetails = [params objectForKey:WSI_KEY_REQUEST_DATA_MODEL];
    if(homeListDetails.searchName != NULL) {
        url = [NSString stringWithFormat:@"%@%@/%@",
               WS_URL_HOMELIST_SEARCH,
               REQ_KEYWORD, homeListDetails.searchName];
        url = WS_URL_HOMELIST_SEARCH;
    } else {
		url = [NSString stringWithFormat:@"%@%@/%@",
				WS_URL_HOMELIST,
				REQ_LOCATION, homeListDetails.requestName];
        url = WS_URL_HOMELIST;
    }
    if(url) [wsParams setObject:url forKey:WSI_KEY_WSC_URL];
    
    // Step 2 - Not Required as it is defaulted to GET which is required here
    // Step 3 - Not Required as it should be nil.
    // Step 4 - Not required
    
    // Should be last statement
    return [super encodeRequestParams:wsParams];
}

@end
