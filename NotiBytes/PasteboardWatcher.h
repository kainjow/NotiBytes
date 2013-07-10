//
//  Created by Kevin Wojniak on 7/9/13.
//  Copyright (c) 2013 Kevin Wojniak. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void (^PasteboardHandler)(NSPasteboard *pboard);

@interface PasteboardWatcher : NSObject

- (instancetype)initWithPasteboard:(NSPasteboard*)pboard handler:(PasteboardHandler)handler;

@end
