//
//  ViewController.swift
//  ICycleView
//  
//  Created by xialuo on 2018/7/5.
//  Copyright © 2018年 Hangzhou Gravity Cyberinfo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 手机屏幕间的比例
    var scaleForPlus: CGFloat {
        return UIScreen.main.bounds.width/414
    }
    
    // 图片
    let pictures = ["http://goodreading.mobi/StudentApi/UserFiles/Banner/Student/Home/banner_tz.png", "http://goodreading.mobi/StudentApi/UserFiles/Banner/Student/Home/banner_dzsyy.png", "http://goodreading.mobi/studentapi/userfiles/banner/student/home/studenttj.png"]
    
    // 默认滚动视图
    lazy var defaultCycleView: ICycleView = {
        let cycleView = ICycleView(frame: CGRect(x: 0, y: 70, width: UIScreen.main.bounds.width, height: 130*scaleForPlus))
        view.addSubview(cycleView)
        return cycleView
    }()
    
    // 自定义图片宽度和指示器的位置和颜色
    lazy var customPagetrolPositionnCycleView: ICycleView = {
        let cycleView = ICycleView(frame: CGRect(x: 0, y: 220, width: UIScreen.main.bounds.width, height: 130*scaleForPlus))
        cycleView.imgViewWidth = 374*scaleForPlus
        cycleView.pageIndicatorTintColor = .green
        view.addSubview(cycleView)
        return cycleView
    }()
    
    // 自定义Cell(纯代码和Xib创建都支持)
    lazy var customPictureCellCycleView: ICycleView = {
        let cycleView = ICycleView(frame: CGRect(x: 0, y: 385, width: UIScreen.main.bounds.width, height: 130*scaleForPlus))
        cycleView.register([UINib.init(nibName: "CustomCycleViewCell", bundle: nil)], identifiers: ["CustomCell"])
        cycleView.delegate = self
        view.addSubview(cycleView)
        return cycleView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 默认滚动视图
        defaultCycleView.pictures = pictures
        
        // 自定义图片宽度和指示器(位置和颜色)
        customPagetrolPositionnCycleView.pictures = pictures
        // pageControlStyle属性必须在设置 pictures 后赋值，因为指示器是根据 numberOfPages 计算Size的
        customPagetrolPositionnCycleView.pageControlStyle = .bottom(bottom: -20)
        customPagetrolPositionnCycleView.pageControlStyle = .right(trailing: 30*scaleForPlus)
        
        // 自定义Cell
        customPictureCellCycleView.pictures = pictures
        
    }

}


// MARK: ICycleViewDelegate
extension ViewController: ICycleViewDelegate {
    
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
    
}

