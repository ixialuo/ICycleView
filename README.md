# ICycleView

ICycleView是一个用于Swift语言中轻量级图片无限轮播

### 现有轮播图
* 不支持单张图片，单张图片时也滚动
* 滚动指示器位置不能精确到自己想要的位置

### 简单实例

```swift 
// 轮播图
private lazy var cycleView: ICycleView = {
    let cycleView = ICycleView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: bannerBgViewHeight.constant))
    cycleView.delegate = self
    bannerBgView.addSubview(cycleView)
    return cycleView
}()
```


### 联系方式
QQ: 2256472253<br>
Email: ixialuo@126.com
