//
//  DJCollectionViewReusableTitleView.m
//  DJComponentCollectionViewVM
//
//  Created by Dokay on 16/7/20.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionViewReusableTitleView.h"

@implementation DJCollectionViewReusableTitle

@end

@interface DJCollectionViewReusableTitleView ()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation DJCollectionViewReusableTitleView
@synthesize reusableVM = _reusableVM;

+ (CGSize)sizeWithResuableVM:(DJCollectionViewReusableTitle *)resuableVM collectionViewVM:(DJCollectionViewVM *)collectionViewVM
{
    CGSize size = [resuableVM.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    return CGSizeMake(size.width + 20, size.height + 40);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addSubview:self.contentLabel];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentLabel)]];
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    self.contentLabel.text = self.reusableVM.title;
    self.backgroundColor = [UIColor whiteColor];
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
