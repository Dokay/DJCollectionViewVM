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
@import UIKit;

@protocol DJCollectionViewVMDelegate <UICollectionViewDelegateFlowLayout>

- (void)collectionView:(UICollectionView *)collectionView willLoadCell:(UICollectionViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(UICollectionView *)collectionView didLoadCell:(UICollectionViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol DJCollectionViewVMDataSource <UICollectionViewDataSource>


@end

@interface DJCollectionViewVM : NSObject<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) id<DJCollectionViewVMDelegate> delegate;
@property (nonatomic, weak) id<DJCollectionViewVMDataSource> dataSource;
@property (nonatomic, strong) NSMutableDictionary *registeredClasses;
@property (nonatomic, strong) NSArray *sections;

- (id)initWithCollectionView:(UICollectionView *)collectionView delegate:(id<DJCollectionViewVMDelegate>)delegate;
- (id)initWithCollectionView:(UICollectionView *)collectionView;

- (id)objectAtKeyedSubscript:(id <NSCopying>)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

- (void)addSection:(DJCollectionViewVMSection *)section;
- (void)addSectionsFromArray:(NSArray *)array;
- (void)insertSection:(DJCollectionViewVMSection *)section atIndex:(NSUInteger)index;
- (void)removeSection:(DJCollectionViewVMSection *)section;
- (void)removeSectionAtIndex:(NSUInteger)index;
- (void)removeSectionsInArray:(NSArray *)otherArray;
- (void)removeAllSections;

@end
