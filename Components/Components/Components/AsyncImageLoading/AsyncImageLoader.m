//
//  AsyncImageLoader.m
//  AsyncImageLoading
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

#import "AsyncImageLoader.h"
#import "AsyncImageRecord.h"

@interface AsyncImageLoader()
@property(nonatomic,retain) NSMutableDictionary *imageRecords;
@end

@implementation AsyncImageLoader

@synthesize defaultImage = _defaultImage;
@synthesize failedImage	 = _failedImage;
@synthesize imageRecords = _imageRecords;

#pragma mark - Lazy instantiation.

-(NSString *)defaultImage {
    if (!_defaultImage) {
        _defaultImage = @"placeholder.png";
    }
    return _defaultImage;
}

-(NSString *)failedImage {
    if (!_failedImage) {
        _failedImage = @"failed.png";
    }
    return _failedImage;
}

-(NSMutableDictionary *)imageRecords {
    if (!_imageRecords) {
        _imageRecords = [[NSMutableDictionary alloc] init];
    }
    return _imageRecords;
}

#pragma mark - De-Allocs

-(void)releaseMem {
    RELEASE_MEM(_imageRecords);
}

-(void) dealloc {
    [self releaseMem];
#if !(__has_feature(objc_arc))
    [super dealloc];
#endif
}

-(void)updateImageView:(UIImageView *)imageView imageUrl:(NSString *)imageUrl {
    
    UIImage *updatedImage;
    
	if([imageUrl rangeOfString:@"http"].location == NSNotFound) {
    	updatedImage = [UIImage imageNamed:imageUrl];
	    imageView.image = updatedImage;
        return;
    }
    
    updatedImage = [UIImage imageNamed:self.defaultImage];
    
    AsyncImageRecord *imgRecord = [self.imageRecords objectForKey:imageUrl];
    if(!imgRecord) {
        imgRecord = [[AsyncImageRecord alloc] init];
        imgRecord.image = NULL;
        imgRecord.imageUrl = [NSURL URLWithString:imageUrl];
        [self.imageRecords setObject:imgRecord forKey:imageUrl];
    }
    
    if(imgRecord) {
        if (imgRecord.image != NULL) {
            updatedImage = imgRecord.image;
        } else if(imgRecord.isFailed) {
            updatedImage = [UIImage imageNamed:self.failedImage];
        } else {
            NSOperationQueue *imgDowloadQueue = [[NSOperationQueue alloc] init];
            [imgDowloadQueue addOperationWithBlock:^{
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:imgRecord.imageUrl];
                if (imageData) {
                    imgRecord.image = [UIImage imageWithData:imageData];
                } else {
                    imgRecord.failed = YES;
                }
                RELEASE_MEM(imageData);
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    imageView.image = imgRecord.image;
                }];
            }];
        }
    }
    
    imageView.image = updatedImage;
}

@end
