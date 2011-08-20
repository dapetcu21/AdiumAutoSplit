//
//  PHAutoSplit.h
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

#import <Adium/AIPlugin.h>
#import <Adium/AIContentControllerProtocol.h>

@interface PHAutoSplit : NSObject <AIPlugin, AIContentFilter>{
    BOOL enabled;
    int chars;
}

- (void) prefsChanged;
@end
