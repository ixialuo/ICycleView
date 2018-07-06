# ICycleView

ICycleView是一个用于Swift语言中轻量级图片无限轮播

### 现有轮播图
* 不支持单张图片，单张图片时也滚动
* 滚动指示器位置不能精确到自己想要的位置

### 简单实例

* 默认滚动视图
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

* 自定义图片宽度和指示器的位置和颜色
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

* 自定义Cell(纯代码和Xib创建都支持)
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
```

### 联系方式
QQ: 2256472253<br>
Email: ixialuo@126.com
