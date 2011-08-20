//
//  PHAutoSplit.m
//  AdiumAutoSplit
//
//  Created by Marius Petcu on 8/16/11.
//  Copyright 2011 Marius Petcu. All rights reserved.
//
// This program is free software. It comes without any warranty, to
// the extent permitted by applicable law. You can redistribute it
// and/or modify it under the terms of the Do What The Fuck You Want
// To Public License, Version 2, as published by Sam Hocevar. See
// http://sam.zoy.org/wtfpl/COPYING for more details.

#import "PHAutoSplit.h"
#import "PHPreferencePane.h"
#import <Adium/AIPreferenceControllerProtocol.h>
#import <Adium/AIContentMessage.h>
#include <objc/objc-runtime.h>

@implementation PHAutoSplit

- (void) installPlugin
{
    NSLog(@"PHAutoSplit: installPlugin");
    [[adium preferenceController] addAdvancedPreferencePane:[[[PHPreferencePane alloc] init] autorelease]];
    [[adium contentController] registerContentFilter:self ofType:AIFilterContent direction:AIFilterOutgoing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prefsChanged) name:PH_NOTIF_NAME object:NULL];
    [self prefsChanged];
}

- (void) prefsChanged
{
    NSNumber * nr = (NSNumber*)[[adium preferenceController] preferenceForKey:PH_PREF_CHARS group:PH_PREF_GROUP];
    int n = [nr intValue];
    if (n<=0)
        n = PH_PREF_DEFAULTCHARS;
    
    NSNumber * en = (NSNumber*)[[adium preferenceController] preferenceForKey:PH_PREF_ENABLE group:PH_PREF_GROUP];
    bool e = true;
    if (en)
        e = [en boolValue];

    enabled = e;
    chars = n;
    
}

- (void) uninstallPlugin
{
    NSLog(@"PHAutoSplit: uninstallPlugin");
}

- (NSAttributedString *)filterAttributedString:(NSAttributedString *)str context:(id)context
{
    if (!enabled)
        return str;
    if (![context isKindOfClass:[AIContentMessage class]] || [context isKindOfClass:objc_getClass("AIContentContext")])
        return str;
    AIContentMessage * origMsg = (AIContentMessage*)context;
    if (!origMsg.sendContent || !origMsg.postProcessContent)
        return str;
    NSUInteger len = [str length];
    if (len<=chars)
        return str;
    
    NSDate * dt = origMsg.date;
    while (len>chars)
    {
        NSAttributedString * beg = [str attributedSubstringFromRange:NSMakeRange(0, chars)];
        NSAttributedString * rem = [str attributedSubstringFromRange:NSMakeRange(chars, len-chars)];
        str = rem;
        len -= chars;
        
        AIContentMessage * msg = [AIContentMessage
                                  messageInChat:origMsg.chat
                                  withSource:origMsg.source
                                  destination:origMsg.destination
                                  date:dt
                                  message:beg
                                  autoreply:origMsg.isAutoreply
                                  ];
        [[adium contentController] sendContentObject:msg];
        dt = [dt dateByAddingTimeInterval:0.1f];
    }
    if (len)
    {
        AIContentMessage * msg = [AIContentMessage
                                  messageInChat:origMsg.chat
                                  withSource:origMsg.source
                                  destination:origMsg.destination
                                  date:dt
                                  message:str
                                  autoreply:origMsg.isAutoreply
                                  ];
        [[adium contentController] sendContentObject:msg];
    }
    return nil;
}

- (CGFloat)filterPriority
{
    return LOWEST_FILTER_PRIORITY;
}

@end
