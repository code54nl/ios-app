//
//  PRLabel.h
//  Uurapp
//
// From: http://www.pietrorea.com/2012/07/how-to-hide-the-cursor-in-a-uitextfield/
//
//  Created by Code54 on 3/13/13.
//  Copyright (c) 2013 Code54 BV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRLabel : UILabel

@property (strong, nonatomic, readwrite) UIView* inputView;
@property (strong, nonatomic, readwrite) UIView* inputAccessoryView;


@end