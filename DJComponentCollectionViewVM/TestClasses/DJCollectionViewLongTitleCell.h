//
//  DJCollectionViewLongTitleCell.h
//  DJComponentCollectionViewVM
//
//  Created by Dokay on 16/7/19.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJCollectionViewVMCell.h"
#import "DJCollectionViewVMRow.h"

@interface DJCollectionViewLongTitleCellRow : DJCollectionViewVMRow

@property (nonatomic, strong) NSString *title;

@end

@interface DJCollectionViewLongTitleCell : DJCollectionViewVMCell

@property (nonatomic, strong) DJCollectionViewLongTitleCellRow *rowVM;

@end
