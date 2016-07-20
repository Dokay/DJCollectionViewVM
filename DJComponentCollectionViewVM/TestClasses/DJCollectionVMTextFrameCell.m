//
//  DJCollectionVMTextFrameCell.m
//  DJComponentCollectionViewVM
//
//  Created by Dokay on 16/7/20.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionVMTextFrameCell.h"

@interface DJCollectionVMTextFrameCell()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation DJCollectionVMTextFrameCell
@synthesize rowVM = _rowVM;

- (void)cellDidLoad
{
    [super cellDidLoad];
    
    [self.contentView addSubview:self.contentLabel];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    self.contentLabel.text = self.rowVM.title;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentLabel.frame = self.contentView.bounds;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize titleSize = [self.rowVM.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    return CGSizeMake(titleSize.width + 20, titleSize.height + 10);
}

#pragma mark - getter
- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

@end
