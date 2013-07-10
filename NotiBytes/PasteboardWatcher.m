//
//  Created by Kevin Wojniak on 7/9/13.
//  Copyright (c) 2013 Kevin Wojniak. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this
//  software and associated documentation files (the "Software"), to deal in the Software
//  without restriction, including without limitation the rights to use, copy, modify,
//  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies
//  or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
//  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
//  THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "PasteboardWatcher.h"

@implementation PasteboardWatcher
{
    NSPasteboard *pboard_;
    NSTimer *pboardTimer_;
    NSInteger lastChangeCount_;
    PasteboardHandler handler_;
}

- (instancetype)initWithPasteboard:(NSPasteboard*)pboard handler:(PasteboardHandler)handler
{
    self = [super init];
    if (self != nil) {
        pboard_ = pboard;
        pboardTimer_ = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(checkPasteboard) userInfo:nil repeats:YES];
        lastChangeCount_ = [pboard_ changeCount];
        handler_ = [handler copy];
    }
    return self;
}

- (void)checkPasteboard
{
	NSInteger currentChangeCount = [pboard_ changeCount];
	if (currentChangeCount == lastChangeCount_) {
		return;
    }
    handler_(pboard_);
	lastChangeCount_ = currentChangeCount;
}

@end
