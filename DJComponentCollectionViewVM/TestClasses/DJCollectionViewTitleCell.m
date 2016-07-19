//
//  DJCollectionViewTitleCell.m
//  DJCollectionViewVM
//
//  Created by Dokay on 16/7/19.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionViewTitleCell.h"

@implementation DJCollectionViewTitleCellRow

@end


@interface DJCollectionViewTitleCell()

@property (nonatomic, strong) UILabel *contentLabel;


@end

@implementation DJCollectionViewTitleCell
@synthesize rowVM = _rowVM;

+ (CGSize)sizeWithRow:(DJCollectionViewTitleCellRow *)row collectionViewVM:(DJCollectionViewVM *)collectionViewVM
{
    CGSize size = [row.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    return CGSizeMake(size.width + 20, size.height + 10);
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentLabel)]];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    
    self.contentLabel.text = self.rowVM.title;
}

#pragma mark - getter
- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentLabel;
}

@end
