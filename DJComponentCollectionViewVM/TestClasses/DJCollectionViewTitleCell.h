//
//  DJCollectionViewTitleCell.h
//  DJCollectionViewVM
//
//  Created by Dokay on 16/7/19.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionViewVMCell.h"
#import "DJCollectionViewVMRow.h"

@interface DJCollectionViewTitleCellRow : DJCollectionViewVMRow

@property (nonatomic, strong) NSString *title;

@end

@interface DJCollectionViewTitleCell : DJCollectionViewVMCell

@property (nonatomic, strong) DJCollectionViewTitleCellRow *rowVM;

@end
