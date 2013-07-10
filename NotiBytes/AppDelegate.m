//
//  Created by Kevin Wojniak on 7/9/13.
//  Copyright (c) 2013 Kevin Wojniak. All rights reserved.
//

#import "AppDelegate.h"
#import "PasteboardWatcher.h"

@interface AppDelegate (Private)
- (void)handleText:(NSString*)text;
@end

@implementation AppDelegate
{
    PasteboardWatcher *pboardWatcher_;
    NSString *lastString_;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    pboardWatcher_ = [[PasteboardWatcher alloc] initWithPasteboard:[NSPasteboard generalPasteboard] handler:^(NSPasteboard *pboard) {
        NSString *str = [pboard stringForType:NSStringPboardType];
        if (![str isEqualToString:lastString_]) {
            [self handleText:[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            lastString_ = str;
        }
    }];
}

- (void)handleValue:(int64_t)value forText:(NSString*)text
{
    if (value <= 0) {
        return;
    }
    NSUserNotification *notif = [[NSUserNotification alloc] init];
    NSString *valueFormatted = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:value] numberStyle:NSNumberFormatterDecimalStyle];
    notif.title = [NSString stringWithFormat:@"%@ (%@)", valueFormatted, text];
    NSString *msg = [NSString stringWithFormat:@"Binary: %@\nDecimal: %@",
                     [NSByteCountFormatter stringFromByteCount:value countStyle:NSByteCountFormatterCountStyleBinary],
                     [NSByteCountFormatter stringFromByteCount:value countStyle:NSByteCountFormatterCountStyleDecimal]];
    notif.informativeText = msg;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notif];
}

- (BOOL)tryExpression:(NSString*)text
{
    @try {
        // If the user copies a string with format specifiers in it, it might cause a crash
        // when using expressionWithFormat:, but if we use the argumentArray: param with an
        // empty array, Cocoa will throw an exception which we can ignore.
        NSExpression *exp = [NSExpression expressionWithFormat:text argumentArray:@[]];
        if (exp != nil) {
            id expValue = [exp expressionValueWithObject:nil context:nil];
            if (expValue != nil && [expValue isKindOfClass:[NSNumber class]]) {
                [self handleValue:[expValue longLongValue] forText:text];
                return YES;
            }
        }
    } @catch (NSException *ex) {
        return NO;
    }
}

- (BOOL)tryLocalized:(NSString*)text
{
    @try {
        NSScanner *scanner = [NSScanner scannerWithString:text];
        int64_t value;
        if ([scanner scanLongLong:&value] && [scanner isAtEnd]) {
            [self handleValue:value forText:text];
            return YES;
        }
    } @catch (NSException *ex) {
        return NO;
    }
}

- (void)handleText:(NSString*)text
{
    if ([self tryExpression:text]) {
        return;
    }
    if ([self tryLocalized:text]) {
        return;
    }
}

@end

int main(int argc, const char * argv[])
{
    AppDelegate *controller = [[AppDelegate alloc] init];
    NSApplication *app = [NSApplication sharedApplication];
    app.delegate = controller;
    [app run];
    return EXIT_SUCCESS;
}
