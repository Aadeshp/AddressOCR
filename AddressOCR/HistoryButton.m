//
//  HistoryButton.m
//  AddressOCR
//
//  Created by Aadesh Patel on 12/24/14.
//  Copyright (c) 2014 Aadesh Patel. All rights reserved.
//

#import "HistoryButton.h"

@implementation HistoryButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *historyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        //Add Image
        [self addSubview:historyIcon];
        
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 2;
        self.layer.cornerRadius = 25.0f;
    }
    
    return self;
}

@end
