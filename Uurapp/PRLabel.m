//
//  PRLabel.m
//  Uurapp
//
//
// From: http://www.pietrorea.com/2012/07/how-to-hide-the-cursor-in-a-uitextfield/
//
//  Created by Code54 on 3/13/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import "PRLabel.h"

@implementation PRLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)isUserInteractionEnabled
{
   return YES;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

# pragma mark - UIResponder overrides

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self becomeFirstResponder];
}

@end