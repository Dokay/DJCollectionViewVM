//
//  DJCollectionViewImageCell.h
//  DJCollectionViewVM
//
//  Created by Dokay on 16/2/25.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionViewVMCell.h"
#import "DJCollectionViewVMRow.h"

@interface DJCollectionViewImageRow : DJCollectionViewVMRow

@property (nonatomic, strong) UIImage *image;

@end

@interface DJCollectionViewImageCell : DJCollectionViewVMCell

@property (nonatomic, strong) DJCollectionViewImageRow *rowVM;

@end
