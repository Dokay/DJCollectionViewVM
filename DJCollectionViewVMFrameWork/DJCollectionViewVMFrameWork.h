//
//  DJCollectionViewVMFrameWork.h
//  DJCollectionViewVMFrameWork
//
//  Created by Dokay on 16/10/25.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef DJCollectionViewVMFrameWork_h
#define DJCollectionViewVMFrameWork_h

#if __has_include(<DJCollectionViewVMFrameWork/DJCollectionViewVMFrameWork.h>)

//! Project version number for DJCollectionViewVMFrameWork.
FOUNDATION_EXPORT double DJCollectionViewVMFrameWorkVersionNumber;

//! Project version string for DJCollectionViewVMFrameWork.
FOUNDATION_EXPORT const unsigned char DJCollectionViewVMFrameWorkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <DJCollectionViewVMFrameWork/PublicHeader.h>

#import <DJCollectionViewVMFrameWork/DJCollectionViewVM.h>
#import <DJCollectionViewVMFrameWork/DJCollectionViewVMSection.h>
#import <DJCollectionViewVMFrameWork/DJCollectionViewVMRow.h>
#import <DJCollectionViewVMFrameWork/DJCollectionViewVMCell.h>
#import <DJCollectionViewVMFrameWork/DJCollectionViewVMReusable.h>
#import <DJCollectionViewVMFrameWork/DJCollectionViewVMReusableView.h>

#else

#import "DJCollectionViewVM.h"
#import "DJCollectionViewVMSection.h"
#import "DJCollectionViewVMRow.h"
#import "DJCollectionViewVMCell.h"
#import "DJCollectionViewVMReusable.h"
#import "DJCollectionViewVMReusableView.h"

#endif /* __has_include */

#endif /* DJCollectionViewVMFrameWork_h */
