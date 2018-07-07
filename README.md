# ICycleView

ICycleView是一个基于UICollectionView实现的轻量级无限轮播图

<br>
<img src="DemoResources/icycleview.gif" width="300" height="600" title="效果图">

# Content

- [Features](#features)
- [Requirements](#requirements)
- [CocoaPods](#cocoapods)
- [Usage](#usage)
    - [默认滚动视图](#默认滚动视图)
    - [自定义图片宽度和指示器的位置和颜色](#自定义图片宽度和指示器的位置和颜色)
    - [自定义Cell-纯代码和Xib创建都支持](#自定义cell-纯代码和xib创建都支持)
- [Implementation](#implementation)
    - [实现原理](#实现原理-详细)
    - [主要代码](#主要代码)
- [Contact](#contact)
- [License](#license)


# Features

- [x] 支持单张图片
- [x] 支持滚动图片宽度设置
- [x] 支持本地图片显示，网路图显示，本地图片和网路图混合显示
- [x] 支持自定义图片展示Cell（纯代码和Xib创建都支持）
- [x] 支持UIPageControl具体位置设置
- [x] 支持UIPageControl显示颜色设置
- [x] 支持图片点击回调
- [x] 支持图片滚动回调

# Requirements

* iOS 8.0+

* Swift 4.0+


# [CocoaPods](http://cocoapods.org)

```ruby
pod 'ICycleView', '~> 1.0.0'
```
在终端 `pod search 'ICycleView'` 时若出现 `Unable to find a pod with name, author, summary, or description matching 'ICycleView'` 错误<br>
请在终端运行<br>
1. `pod setup`<br>
2. `$rm ~/Library/Caches/CocoaPods/search_index.json`


# Usage

#### 默认滚动视图

<img src="DemoResources/default_icycleview.gif" title="默认滚动视图">

```swift 
// 惰性初始化滚动视图
lazy var defaultCycleView: ICycleView = {
    let cycleView = ICycleView(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 130*scaleForPlus))
    view.addSubview(cycleView)
    return cycleView
}()

// 图片赋值
defaultCycleView.pictures = pictures
```


#### 自定义图片宽度和指示器的位置和颜色

<img src="DemoResources/custom_pagecontrol_icycleview.gif" title="自定义图片宽度和指示器的位置和颜色">

```swift
// 惰性初始化滚动视图
lazy var customPagetrolPositionnCycleView: ICycleView = {
    let cycleView = ICycleView(frame: CGRect(x: 0, y: 190, width: UIScreen.main.bounds.width, height: 130*scaleForPlus))
    cycleView.imgViewWidth = 374*scaleForPlus
    cycleView.pageIndicatorTintColor = .green
    view.addSubview(cycleView)
    return cycleView
}()

// 图片赋值
customPagetrolPositionnCycleView.pictures = pictures
// pageControlStyle属性必须在设置 pictures 后赋值，因为指示器是根据 numberOfPages 计算Size的
customPagetrolPositionnCycleView.pageControlStyle = .bottom(bottom: -20)
customPagetrolPositionnCycleView.pageControlStyle = .right(trailing: 30*scaleForPlus)
```

#### 自定义Cell-纯代码和Xib创建都支持

<img src="DemoResources/custom_cell_icycleview.gif" title="自定义Cell-纯代码和Xib创建都支持">

```swift
// 惰性初始化滚动视图
lazy var customPictureCellCycleView: ICycleView = {
    let cycleView = ICycleView(frame: CGRect(x: 0, y: 345, width: UIScreen.main.bounds.width, height: 130*scaleForPlus))
    cycleView.register([UINib.init(nibName: "CustomCycleViewCell", bundle: nil)], identifiers: ["CustomCell"])
    cycleView.delegate = self
    view.addSubview(cycleView)
    return cycleView
}()

// 图片赋值
customPictureCellCycleView.pictures = pictures

// 代理方法

/**
 - 协议方法都是可选方法，根据需要实现即可
 */
// MARK: ICycleViewDelegate
extension ViewController: ICycleViewDelegate {

    // 图片点击
    func iCycleView(cycleView: ICycleView, didSelectItemAt index: Int) {
        print("你点击了第 \(index) 张图片")
    }

    // 图片自动滚动
    func iCycleView(cycleView: ICycleView, autoScrollingItemAt index: Int) {
        print("当前滚动的图片是第 \(index) 张")
    }

    // 自定义Cell
    func iCycleView(cycleView: ICycleView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, picture: String) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCycleViewCell
        cell.imgView.kf.setImage(with: URL(string: picture))
        cell.titleLab.text = "自定义Cell\n第 \(indexPath.item) 张图片"
        return cell
    }

}
```


# Implementation

#### 实现原理 [[详细]](https://www.jianshu.com/p/2b5ff0cb9b06)
1. collectionView的cell显示两倍数量的图片，展示图片分为两组，默认显示第二组的第一张
2. 左滑collectionView到第二组最后一张，即最后一个cell时，设置scrollView的contentOffset显示第一组的最后一张，继续左滑，实现了无限左滑
3. 右滑collectionView到第一组第一张，即第一cell时，设置scrollView的contentOffset显示第二组的第一张，继续右滑，实现了无限右滑
4. 由2，3实现无限循环

#### 主要代码

```swift
// MARK: - 监听手动减速完成(停止滚动)
public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let offsetX = scrollView.contentOffset.x
    let page = Int(offsetX / bounds.size.width)
    let itemsCount = collectionView.numberOfItems(inSection: 0)
    if page == 0 {
        // 第一页
        collectionView.contentOffset = CGPoint(x: offsetX + CGFloat(pictures.count) * bounds.size.width, y: 0)
    } else if page == itemsCount - 1 {
        // 最后一页
        collectionView.contentOffset = CGPoint(x: offsetX - CGFloat(pictures.count) * bounds.size.width, y: 0)
    }
}
```


# Contact

QQ: 2256472253<br>
Email: ixialuo@126.com


# License

ICycleView is released under the MIT license. [See LICENSE](LICENSE) for details.
