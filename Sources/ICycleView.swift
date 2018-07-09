//
//  ICycleView.swift
//  ICycleView
//
//  Created by xialuo on 2018/7/5.
//  Copyright © 2018年 Hangzhou Gravity Cyberinfo. All rights reserved.
//

import UIKit
import Kingfisher

// MARK: - 指示器位置枚举，通过枚举关联值设置具体位置
public enum IPageControlStyle {
    case center                         // 中间
    case left(leading: CGFloat)         // 距左多少
    case right(trailing: CGFloat)       // 距右多少
    case bottom(bottom: CGFloat)        // 距底部多少
}


// MARK: - ICycleView常量
private struct ICycleViewConst {
    static let cellIdentifier = "ICycleViewCell"        // Cell标识
    static let pageControlHeight: CGFloat = 19          // 指示器高度
}


// MARK: - ICycleViewDelegate 代理方法
@objc public protocol ICycleViewDelegate: NSObjectProtocol {
    
    // 图片点击
    @objc optional func iCycleView(cycleView: ICycleView, didSelectItemAt index: Int)
    
    // 图片自动滚动
    @objc optional func iCycleView(cycleView: ICycleView, autoScrollingItemAt index: Int)
    
    // 自定义Cell
    @objc optional func iCycleView(cycleView: ICycleView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, picture: String) -> UICollectionViewCell
}


// MARK: - ICycleView
public class ICycleView: UIView {

    // TODO: 1.懒加载的控件
    // collectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = bounds.size
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ICycleViewCell.self, forCellWithReuseIdentifier: ICycleViewConst.cellIdentifier)
        return collectionView
    }()
    
    // 图片滚动指示器
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: bounds.height-ICycleViewConst.pageControlHeight, width: bounds.width, height: ICycleViewConst.pageControlHeight))
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        pageControl.isHidden = true
        return pageControl
    }()
    
    // 定时器
    private lazy var timer: Timer = {
        let timer = Timer(timeInterval: autoScrollDelay, target: self, selector: #selector(updateCollectionViewAutoScrolling), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
        return timer
    }()
    
    // TODO: 2.外部不可访问的属性
    // 是否自定义Cell
    private var isCustomCell = false
    
    // TODO: 3.外部访问属性
    // 代理
    public weak var delegate: ICycleViewDelegate?
    
    // 自动播放时间 默认5秒
    open var autoScrollDelay: TimeInterval = 5
    
    // 轮播图片的宽度
    open var imgViewWidth = UIScreen.main.bounds.width
    
    // 默认图
    open var placeholderImage: UIImage?
    
    // 指示器默认颜色
    open var pageIndicatorTintColor = UIColor.white {
        didSet {
            pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        }
    }
    
    // 指示器选中颜色
    open var currentPageIndicatorTintColor = UIColor.orange {
        didSet {
            pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        }
    }
    
    /**
     - 指示器位置
     - 通过枚举关联值设置具体位置
     - 注: 这个属性必须在设置 pictures 后赋值，因为指示器是根据 numberOfPages 计算Size的
     */
    open var pageControlStyle: IPageControlStyle = .center {
        didSet {
            guard pictures.count != 0 else { return }
            let pageControlSize = pageControl.size(forNumberOfPages: pictures.count)
            
            switch pageControlStyle {
            case .left(let leading):
                pageControl.center.x = pageControlSize.width/2 + leading
                
            case .right(let trailing):
                pageControl.center.x = bounds.width - pageControlSize.width/2 - trailing
                
            case .center:
                pageControl.center.x = bounds.width/2
                
            case .bottom(let bottom):
                pageControl.center.y = bounds.height - ICycleViewConst.pageControlHeight/2 - bottom
            }
        }
    }
    
    /**
     - 展示图片数组
     - 支持本地图片和网络图片，根据图片名是否以“http”开头自动识别
     */
    open var pictures: [String] = [] {
        didSet {
           
            // 没有图片时，不处理
            guard pictures.count != 0 else { return }
            
            // 通过oldValue是否有值，判别页面刷新时是否需要赋值，防止每次刷新页面又从第一张图开始滚动
            guard oldValue.count == 0 else { return }
            
            collectionView.reloadData()
            // 图片数量大于1时可以滑动
            collectionView.isScrollEnabled = pictures.count > 1
            // 滚动到中间位置
            let indexPath: IndexPath = IndexPath(item: pictures.count, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            
            // 图片数量小于2时不展示指示器
            pageControl.isHidden = pictures.count < 2
            pageControl.numberOfPages = pictures.count
            
            if pictures.count > 1 {
                timer.fireDate = Date(timeIntervalSinceNow: autoScrollDelay)
            } else {
                // 防止列表滚动时复用
                timer.fireDate = Date.distantFuture
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        
        addSubview(pageControl)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(collectionView)
        
        addSubview(pageControl)
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        
        timer.invalidate()
    }
    
    deinit {
        print("ICycleView deinit success")
    }

}


// MARK: - 外部自定义Cell方法
extension ICycleView {
    
    // 自定义 AnyClass cell
    public func register(_ cellClasss: [Swift.AnyClass?], identifiers: [String]) {
        isCustomCell = true
        for (index, identifier) in identifiers.enumerated() {
            collectionView.register(cellClasss[index], forCellWithReuseIdentifier: identifier)
        }
    }
    
    // 自定义 UINib cell
    public func register(_ nibs: [UINib?], identifiers: [String]) {
        isCustomCell = true
        for (index, identifier) in identifiers.enumerated() {
            collectionView.register(nibs[index], forCellWithReuseIdentifier: identifier)
        }
    }
    
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ICycleView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count * 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isCustomCell {
            // 自定义Cell
            return delegate?.iCycleView?(cycleView: self, collectionView: collectionView, cellForItemAt: IndexPath(item: indexPath.item % pictures.count, section: 0), picture: pictures[indexPath.item % pictures.count]) ?? UICollectionViewCell()
        } else {
            // 默认Cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ICycleViewConst.cellIdentifier, for: indexPath) as! ICycleViewCell
            cell.configureCell(picture: pictures[indexPath.item % pictures.count], placeholderImage: placeholderImage, imgViewWidth: imgViewWidth)
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.iCycleView?(cycleView: self, didSelectItemAt: indexPath.item % pictures.count)
    }
    
}


// MARK: - 循环轮播实现
extension ICycleView {
    
    // 定时器方法，更新Cell位置
    @objc private func updateCollectionViewAutoScrolling() {
        if let indexPath = collectionView.indexPathsForVisibleItems.last {
            let nextPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
            collectionView.scrollToItem(at: nextPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    // 开始拖拽时,停止定时器
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer.fireDate = Date.distantFuture
    }
    
    // 结束拖拽时,恢复定时器
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer.fireDate = Date(timeIntervalSinceNow: autoScrollDelay)
    }
    
    /**
     - 监听手动减速完成(停止滚动)
     - 1.collectionView的cell显示两倍数量的图片，展示图片分为两组，默认显示第二组的第一张
     - 2.左滑collectionView到第二组最后一张，即最后一个cell时，设置scrollView的contentOffset显示第一组的最后一张，继续左滑，实现了无限左滑
     - 3.右滑collectionView到第一组第一张，即第一cell时，设置scrollView的contentOffset显示第二组的第一张，继续右滑，实现了无限右滑
     - 4.由2，3实现无限循环
     */
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
    
    // - 滚动动画结束的时候调用
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(collectionView)
    }
    
    /**
     - 正在滚动
     - 设置分页，算出滚动位置,更新指示器
     */
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        var page = Int(offsetX / bounds.size.width+0.5)
        page = page % pictures.count
        if pageControl.currentPage != page {
            pageControl.currentPage = page
            delegate?.iCycleView?(cycleView: self, autoScrollingItemAt: page)
        }
    }
    
}


// MARK: - 轮播图默认的Cell
fileprivate class ICycleViewCell: UICollectionViewCell {
    
    // 图片控件
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: imgViewWidth, height: bounds.height))
        return imgView
    }()
    
    /**
     - 图片宽度
     - 根据业务需要设置轮播图片的宽度，默认屏幕宽度
     */
    private var imgViewWidth: CGFloat = UIScreen.main.bounds.width {
        didSet {
            if imgViewWidth != UIScreen.main.bounds.width {
                imgView.frame.size.width = imgViewWidth
                imgView.center.x = bounds.width/2
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(imgView)
    }
    
    /**
     - 数据填充方法
     - picture: 需要展示的图片，根据是否以“http”开头判断网路图片还是本地图片
     - placeholderImage: 默认图片
     - imgViewWidth: 图片宽度
     */
    fileprivate func configureCell(picture: String, placeholderImage: UIImage? = nil, imgViewWidth: CGFloat = UIScreen.main.bounds.width) {
        
        if picture.hasPrefix("http") {
            imgView.kf.setImage(with: URL(string: picture), placeholder: placeholderImage)
        } else {
            imgView.image = UIImage(named: picture) ?? placeholderImage
        }
        
        self.imgViewWidth = imgViewWidth
    }
}


