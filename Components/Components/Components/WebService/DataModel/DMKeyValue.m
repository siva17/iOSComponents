//
//  DMKeyValue.m
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

#import "DMKeyValue.h"

@implementation DMKeyValue

@synthesize key   = _key;
@synthesize value = _value;

-(id)initKey:(NSString *)key value:(NSString *)value {
    self = [super init];
    if (self) {
        // Custom initialization
        _key = [NSString stringWithString:key];
        _value = [NSString stringWithString:value];
    }
    return self;
}

-(id)initKey:(NSString *)key boolValue:(BOOL)boolValue {
    self = [super init];
    if (self) {
        // Custom initialization
        _key = [NSString stringWithString:key];
        _value = ((boolValue)?(@"Yes"):(@"No"));
    }
    return self;
}

@end
