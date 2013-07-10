//
//  Created by Kevin Wojniak on 7/9/13.
//  Copyright (c) 2013 Kevin Wojniak. All rights reserved.
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
