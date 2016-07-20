//
//  DJCollectionViewVMCell.m
//  DJCollectionViewVM
//
//  Created by Dokay on 16/2/1.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionViewVMCell.h"
#import "DJCollectionViewVMRow.h"

@implementation DJCollectionViewVMCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CGSize)sizeWithRow:(DJCollectionViewVMRow *)row collectionViewVM:(DJCollectionViewVM *)collectionViewVM
{
    if ([row isKindOfClass:[DJCollectionViewVMRow class]] && row.rowSize.width > 0){
        return row.rowSize;
    }else{
        return CGSizeMake(100, 100);
    }
}

#pragma mark Cell life cycle
- (void)cellDidLoad
{
    self.loaded = YES;
}

- (void)cellWillAppear
{
    DJCollectionViewVMRow *row = self.rowVM;
    
    if (row.backgroundColor) {
        self.backgroundColor = row.backgroundColor;
    }
    if (row.backgroundView) {
        self.backgroundView = row.backgroundView;
    }
    if (row.selectedBackgroundView) {
        self.selectedBackgroundView = row.backgroundView;
    }
}

- (void)cellDidDisappear
{
    
}

@end
