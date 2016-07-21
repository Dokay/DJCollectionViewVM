//
//  DJCollectionViewLongTitleCell.m
//  DJComponentCollectionViewVM
//
//  Created by Dokay on 16/7/19.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionViewLongTitleCell.h"

@interface DJCollectionViewLongTitleCell()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation DJCollectionViewLongTitleCell
@synthesize rowVM = _rowVM;

- (void)prepareForReuse
{
    [super prepareForReuse];
    //preferredMaxLayoutWidth may be changed for caculate height
    self.titleLabel.preferredMaxLayoutWidth = 0.0f;
}

- (void)cellDidLoad
{
    [super cellDidLoad];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    
    self.titleLabel.text = self.rowVM.title;
}

@end
