//
//  PHPreferencePane.m
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

#import "PHPreferencePane.h"
#import <Adium/AIPreferenceControllerProtocol.h>

@implementation PHPreferencePane

#define PH_PANENAME @"AutoSplit"

-(id)initForPlugin:(id)inPlugin
{
    if (self = [super initForPlugin:inPlugin])
    {
    }
    return self;
}

-(NSString*)label
{
    return PH_PANENAME;
}

-(NSImage*)image
{
    return [NSImage imageNamed:@"AdiumPlugin"];
}

- (NSString*)paneName
{
    return PH_PANENAME;
}

-(NSString*)nibName
{
    return @"PHAutoSplit";
}

-(IBAction)changePreference:(id)sender
{
    if (sender == textField)
        [[adium preferenceController] setPreference:[NSNumber numberWithInt:[textField intValue]] forKey:PH_PREF_CHARS group:PH_PREF_GROUP];
    if (sender == enabledButton)
        [[adium preferenceController] setPreference:[NSNumber numberWithBool:([enabledButton state]==NSOnState)] forKey:PH_PREF_ENABLE group:PH_PREF_GROUP];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PH_NOTIF_NAME object:self];
    
    [super changePreference:sender];
}

- (void)configureControlDimming
{
    NSNumber * en = (NSNumber*)[[adium preferenceController] preferenceForKey:PH_PREF_ENABLE group:PH_PREF_GROUP];
    bool e = true;
    if (en)
        e = [en boolValue];
    
    [textField setEnabled:e];
}

- (void)viewDidLoad
{
    NSNumber * nr = (NSNumber*)[[adium preferenceController] preferenceForKey:PH_PREF_CHARS group:PH_PREF_GROUP];
    int n = [nr intValue];
    if (n<=0)
        n = PH_PREF_DEFAULTCHARS;
    [textField setIntValue:n];
    
    NSNumber * en = (NSNumber*)[[adium preferenceController] preferenceForKey:PH_PREF_ENABLE group:PH_PREF_GROUP];
    bool e = true;
    if (en)
        e = [en boolValue];
    [enabledButton setState:e];
    [textField setEnabled:e];
}

/*
-(NSView*)paneView
{
    NSLog(@"paneView");
    NSNib * nib = [[[NSNib alloc] initWithNibNamed:@"PHAutoSplit" bundle:[NSBundle mainBundle]] autorelease];
    NSArray * arr; 
    [nib instantiateNibWithOwner:self topLevelObjects:&arr];
    return [arr objectAtIndex:0];
}*/

-(NSString*)paneIdentifier
{
    NSLog(@"paneID");
    return @"org.porkholt.AutoSplit.prefpane";
}


-(NSComparisonResult)caseInsensitiveCompare:(AIModularPane*)p
{
    NSLog(@"caseInsens");
    return [[self label] caseInsensitiveCompare:[p label]];
}

@end
