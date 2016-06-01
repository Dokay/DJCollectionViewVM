//
//  DJCollectionViewVMCell.h
//  DJCollectionViewVM
//
//  Created by Dokay on 16/2/1.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import <UIKit/UIKit.h>
@import UIKit;
@class DJCollectionViewVM;
@class DJCollectionViewVMSection;
@class DJCollectionViewVMRow;

@protocol DJCollectionViewVMCellDelegate <NSObject>

@property (weak, nonatomic  ) UICollectionView        *parentCollectionView;
@property (weak, nonatomic  ) DJCollectionViewVM *collectionViewVM;
@property (weak, nonatomic  ) DJCollectionViewVMSection *section;
@property (strong, nonatomic) DJCollectionViewVMRow     *rowVM;
@property (assign, nonatomic) NSInteger rowIndex;
@property (assign, nonatomic) NSInteger sectionIndex;
@property (nonatomic, assign) BOOL loaded;

- (void)cellDidLoad;
- (void)cellWillAppear;
- (void)cellDidDisappear;

@optional
+ (CGSize)sizeWithRow:(DJCollectionViewVMRow *)row collectionViewVM:(DJCollectionViewVM *)collectionViewVM;

@end

@interface DJCollectionViewVMCell : UICollectionViewCell<DJCollectionViewVMCellDelegate>

@property (weak, nonatomic  ) UICollectionView        *parentCollectionView;
@property (weak, nonatomic  ) DJCollectionViewVM *collectionViewVM;
@property (weak, nonatomic  ) DJCollectionViewVMSection *section;
@property (strong, nonatomic) DJCollectionViewVMRow     *rowVM;
@property (assign, nonatomic) NSInteger rowIndex;
@property (assign, nonatomic) NSInteger sectionIndex;
@property (nonatomic, assign) BOOL loaded;

- (void)cellDidLoad;
- (void)cellWillAppear;
- (void)cellDidDisappear;

+ (CGSize)sizeWithRow:(DJCollectionViewVMRow *)row collectionViewVM:(DJCollectionViewVM *)collectionViewVM;

@end
