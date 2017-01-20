DJCollectionViewVM
==========

![License MIT](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)
![Pod version](https://img.shields.io/cocoapods/v/DJCollectionViewVM.svg?style=flat)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform info](https://img.shields.io/cocoapods/p/DJCollectionViewVM.svg?style=flat)](http://cocoadocs.org/docsets/YTKNetwork)

## What

__DJCollectionViewVM is a lightweight ViewModel implementation for UICollectionView.__

## Features
* less code and more flexible to implement linear layout using UICollectionView with UICollectionViewFlowLayout;
* dynamic cell and SupplementaryView size caculate;
* header and footer support like UITableView;
* prefetch for iOS 7.0+;

## Requirements
* Xcode 7 or higher
* Apple LLVM compiler
* iOS 7.0 or higher
* ARC

## Demo

Build and run the `DJComponentCollectionViewVM.xcodeproj` in Xcode.


## Installation

###  CocoaPods
Edit your Podfile and add DJCollectionViewVM:

``` bash
pod 'DJCollectionViewVM'
```

## Quickstart
* Sample code
```objc

- (void)testNormal
{
    DJCollectionViewVMCellRegister(self.collectionVM, DJCollectionViewTitleCellRow, DJCollectionViewTitleCell);
    [self.collectionVM removeAllSections];
    
    DJCollectionViewVMSection *contentSection = [DJCollectionViewVMSection sectionWithHeaderHeight:10];
    contentSection.minimumLineSpacing = 10.0f;
    contentSection.minimumInteritemSpacing = 10.0f;
    [self.collectionVM addSection:contentSection];
    for (NSInteger i = 0; i < 100; i ++) {
        DJCollectionViewTitleCellRow *row = [DJCollectionViewTitleCellRow new];
        row.itemSize = CGSizeMake(100, 100);
        row.backgroundColor = [UIColor redColor];
        row.title = [NSString stringWithFormat:@"%@",@(i)];
        [row setSelectionHandler:^(DJCollectionViewVMRow *rowVM) {
            NSLog(@"tap %@",rowVM.indexPath);
        }];
        [contentSection addRow:row];
    }
    
    [self.collectionView reloadData];
}

```

* API
<table>
  <tr><th colspan="2" style="text-align:center;">Key Classes</th></tr>
  <tr>
    <td>DJCollectionViewVM</td>
    <td>The ViewModel for <tt>UICollectionView</tt>, which has implemented UICollectionViewDelegate , UICollectionViewDataSource and UICollectionViewDelegateFlowLayout. It has multiple <tt>DJCollectionViewVMSection</tt> sections.</td>
  </tr>
  <tr>
    <td>DJCollectionViewVMSection</td>
    <td>The ViewModel for sections in <tt>DJCollectionViewVM</tt>, each section has multiple <tt>DJCollectionViewVMRow</tt> rows.</td>
  </tr>
  <tr>
    <td>DJCollectionViewVMRow</td>
    <td>The ViewModel for rows in section,it is the root class of all <tt>DJCollectionViewVM</tt> row hierarchies.<br />
        You should subclass <tt>DJCollectionViewVMRow</tt> to obtain cell characteristics specific to your application's needs.
        Through <tt>DJCollectionViewVMRow</tt>, rows inherit a basic interface that communicates with <tt>DJCollectionViewVM</tt> and <tt>DJCollectionViewVMSection</tt>.</td>
  </tr>
  <tr>
    <td>DJCollectionViewVMCell</td>
    <td>The View for DJCollectionViewVMRow(ViewModel),it defines the attributes and behavior of the cells that appear in <tt>UICollectionView</tt> objects.
        You should subclass <tt>DJCollectionViewVMCell</tt> to obtain cell characteristics and behavior specific to your application's needs.
        By default, it is being mapped with <tt>DJCollectionViewVMRow</tt>.</td>
  </tr>
  <tr>
    <td>DJCollectionViewVMReusable</td>
    <td>The ViewModel for supplementary view in section header and footer,it is the root class of all <tt>DJCollectionViewVM</tt> supplementary view hierarchies.<br />
        You should subclass <tt>DJCollectionViewVMReusable</tt> to obtain supplementary view characteristics specific to your application's needs.
        Through <tt>DJCollectionViewVMReusable</tt>, supplementary views inherit a basic interface that communicates with <tt>DJCollectionViewVM</tt> and <tt>DJCollectionViewVMSection</tt>.</td>
  </tr>
  <tr>
    <td>DJCollectionViewVMReusableView</td>
    <td>The View for DJCollectionViewVMReusable(ViewModel),it defines the attributes and behavior of the supplementary views that appear in <tt>UICollectionView</tt> objects.
        You should subclass <tt>DJCollectionViewVMReusableView</tt> to obtain supplementary view characteristics and behavior specific to your application's needs.
        By default, it is being mapped with <tt>DJCollectionViewVMReusable</tt>.</td>
  </tr>
</table>

* For exsist cells in your project<br />1.If the super class of your cell is UICollectionViewCell ,just change it to DJCollectionViewVMCell.<br />2.If tht super class of your cell is your custom class ,you need to implement the protocol DJCollectionViewVMCellDelegate or change it to DJCollectionViewVMCell.


##UITableView

ViewModel for UITableView: [DJTableViewVM](http://github.com/Dokay/DJTableViewVM)


## Contact

Dokay Dou

- https://github.com/Dokay
- http://www.douzhongxu.com
- dokay_dou@163.com

## License

DJCollectionViewVM is available under the MIT license.
