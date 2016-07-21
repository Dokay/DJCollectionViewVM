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

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes NS_AVAILABLE_IOS(8_0)
{
    return layoutAttributes;
}

+ (CGSize)sizeWithRow:(DJCollectionViewVMRow *)row collectionViewVM:(DJCollectionViewVM *)collectionViewVM
{
    if ([row isKindOfClass:[DJCollectionViewVMRow class]] && row.itemSize.width > 0){
        return row.itemSize;
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
