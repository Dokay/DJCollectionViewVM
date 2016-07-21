//
//  DJCollectionViewVMSection.h
//  DJCollectionViewVM
//
//  Created by Dokay on 16/2/1.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

#define kHeadReuseIdentifier  @"DJCollectionViewVMReusable"
#define kFootReuseIdentifier  @"DJCollectionViewVMReusable"

@class DJCollectionViewVM;
@class DJCollectionViewVMReusable;

@interface DJCollectionViewVMSection : NSObject

/**
 *  array for row's ViewModel
 */
@property (strong, readonly, nonatomic) NSArray *rows;

/**
 *  Normal UIView ,simulation for headerView in UITableView.
 */
@property (strong, nonatomic) UIView *headerView;

/**
 *  Normal UIView ,simulation for footerView in UITableView
 */
@property (strong, nonatomic) UIView *footerView;

/**
 *  property same as sectionInset in UICollectionViewFlowLayout.
 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;

/**
 *  property same as minimumLineSpacing in UICollectionViewFlowLayout.
 */
@property (nonatomic, assign) CGFloat minimumLineSpacing;

/**
 *  property same as minimumInteritemSpacing in UICollectionViewFlowLayout.
 */
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

/**
 *  property same as headerReferenceSize in UICollectionViewFlowLayout.
 */
@property (nonatomic, assign) CGSize headerReferenceSize;

/**
 *  property same as footerReferenceSize in UICollectionViewFlowLayout.
 */
@property (nonatomic, assign) CGSize footerReferenceSize;

/**
 *  current section index in UICollectionView.
 */
@property (assign, readonly, nonatomic) NSUInteger index;

/**
 *  ViewModel of  UICollectionView.
 */
@property (weak, nonatomic) DJCollectionViewVM *collectionViewVM;

/**
 *  ViewModel of SupplementaryView in Header.
 */
@property (nonatomic, strong) DJCollectionViewVMReusable *headerReusabelVM;

/**
 *  ViewModel of SupplementaryView in Footer.
 */
@property (nonatomic, strong) DJCollectionViewVMReusable *footerReusableVM;

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
