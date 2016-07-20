//
//  DJCollectionViewVMSection.h
//  DJCollectionViewVM
//
//  Created by Dokay on 16/2/1.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

#define kHeadReuseIdentifier  @"UICollectionReusableView"
#define kFootReuseIdentifier  @"UICollectionReusableView"

@class DJCollectionViewVM;

@interface DJCollectionViewVMSection : NSObject

@property (strong, readonly, nonatomic) NSArray *rows;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;

@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) CGSize headerReferenceSize;
@property (nonatomic, assign) CGSize footerReferenceSize;

@property (assign, readonly, nonatomic) NSUInteger index;
@property (weak, nonatomic) DJCollectionViewVM *collectionViewVM;

@property (nonatomic, copy) void(^configResuseHeadViewHandler)(UICollectionReusableView *headView,DJCollectionViewVMSection *section);
@property (nonatomic, copy) void(^configResuseFootViewHandler)(UICollectionReusableView *footView,DJCollectionViewVMSection *section);

+ (instancetype)sectionWithHeaderView:(UIView *)headerView;
+ (instancetype)sectionWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView;
+ (instancetype)sectionWithHeaderHeight:(CGFloat)fheight andFooterHeight:(CGFloat)fheight;
+ (instancetype)sectionWithHeaderHeight:(CGFloat)fheight;

- (id)initWithHeaderView:(UIView *)headerView;
- (id)initWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView;

- (void)addRow:(id)row;
- (void)addRowsFromArray:(NSArray *)array;
- (void)insertRow:(id)row atIndex:(NSUInteger)index;
- (void)removeRow:(id)row;
- (void)removeRowAtIndex:(NSUInteger)index;
- (void)removeAllRows;

- (void)reloadSection;

@end
