//
//  PHPreferencePane.h
//  AdiumAutoSplit
//
//  Created by Marius Petcu on 8/16/11.
//  Copyright 2011 Porkholt Labs!. All rights reserved.
//
// This program is free software. It comes without any warranty, to
// the extent permitted by applicable law. You can redistribute it
// and/or modify it under the terms of the Do What The Fuck You Want
// To Public License, Version 2, as published by Sam Hocevar. See
// http://sam.zoy.org/wtfpl/COPYING for more details.

#import <Adium/AIPreferencePane.h>

#define PH_NOTIF_NAME @"PHAutoSplitPrefsChanged"
#define PH_PREF_GROUP @"PHAutoSplit"
#define PH_PREF_CHARS @"autoSplitChars"
#define PH_PREF_ENABLE @"autoSplitEnable"
#define PH_PREF_DEFAULTCHARS 500

@interface PHPreferencePane : AIPreferencePane
{
    IBOutlet NSTextField * textField;
    IBOutlet NSButton * enabledButton;
}

@end
