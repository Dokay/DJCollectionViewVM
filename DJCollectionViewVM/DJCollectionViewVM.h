//
//  DJCollectionViewVM.h
//  DJCollectionViewVM
//
//  Created by Dokay on 16/2/1.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJCollectionViewVMSection.h"
#import "DJCollectionViewVMRow.h"
#import "DJCollectionViewVMReusable.h"

@import UIKit;

#define DJCollectionViewVMCellRegister(DJCollectionViewVMInstance,RowVMClassName,CellClassName) [DJCollectionViewVMInstance setObject:NSStringFromClass([CellClassName class]) forKeyedSubscript:NSStringFromClass([RowVMClassName class])];

#define DJCollectionViewVMResuableRegister(DJCollectionViewVMInstance,ReusableVMClassName,ReusableCellClassName) [DJCollectionViewVMInstance registReusableViewClassName:NSStringFromClass([ReusableCellClassName class]) forReusableVMClassName:NSStringFromClass([ReusableVMClassName class])];

@protocol DJCollectionViewVMDelegate <UICollectionViewDelegateFlowLayout>

@optional
- (void)collectionView:(UICollectionView *)collectionView willLoadCell:(UICollectionViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(UICollectionView *)collectionView didLoadCell:(UICollectionViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol DJCollectionViewVMDataSource <UICollectionViewDataSource>
@end

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
@protocol DJCollectionViewDataSourcePrefetching <NSObject>
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
@end
#else
@protocol DJCollectionViewDataSourcePrefetching <UICollectionViewDataSourcePrefetching>

@end
#endif

@interface DJCollectionViewVM : NSObject<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) id<DJCollectionViewVMDelegate> delegate;
@property (nonatomic, weak) id<DJCollectionViewVMDataSource> dataSource;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, assign) BOOL prefetchingEnabled;

- (id)initWithCollectionView:(UICollectionView *)collectionView delegate:(id<DJCollectionViewVMDelegate>)delegate;
- (id)initWithCollectionView:(UICollectionView *)collectionView;

- (id)objectAtKeyedSubscript:(id <NSCopying>)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;
- (void)registerClass:(NSString *)rowClassName forCellClassName:(NSString *)cellClassName bundle:(NSBundle *)bundle;

- (NSString *)reusableClassNameForViewModelClassName:(NSString *)className;
- (void)registReusableViewClassName:(NSString *)reusableViewClassName forReusableVMClassName:(NSString *)reusableVMClassName;

- (CGSize)sizeWithAutoLayoutCellWithIndexPath:(NSIndexPath *)indexPath;
- (CGSize)sizeWithAutoLayoutReusableViewWithSection:(NSInteger)section isHead:(BOOL)bHead;

- (void)addSection:(DJCollectionViewVMSection *)section;
- (void)addSectionsFromArray:(NSArray *)array;
- (void)insertSection:(DJCollectionViewVMSection *)section atIndex:(NSUInteger)index;
- (void)removeSection:(DJCollectionViewVMSection *)section;
- (void)removeSectionAtIndex:(NSUInteger)index;
- (void)removeSectionsInArray:(NSArray *)otherArray;
- (void)removeAllSections;

@end
