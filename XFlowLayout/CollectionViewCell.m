//
//  CollectionViewCell.m
//  XFlowLayout
//
//  Created by Leo on 2019/10/10.
//  Copyright © 2019 Leo. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat r = arc4random_uniform(255.0) / 255.0;
        CGFloat g = arc4random_uniform(255.0) / 255.0;
        CGFloat b = arc4random_uniform(255.0) / 255.0;
        self.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
        
        // title label
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont boldSystemFontOfSize:20];
        [self.contentView addSubview:_titleLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLab.frame = self.bounds;
}

@end
