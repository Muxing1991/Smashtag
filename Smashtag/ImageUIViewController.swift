//
//  ImageUIViewController.swift
//  Smashtag
//
//  Created by 杨威 on 16/6/11.
//  Copyright © 2016年 demo. All rights reserved.
//

import UIKit

class ImageUIViewController: UIViewController, UIScrollViewDelegate {
  
  @IBOutlet weak var scrollView: UIScrollView!{
    didSet{
      scrollView.contentSize = imageView.frame.size
      scrollView.delegate = self
      //不应该写在这里 因为outlet已经设定了但是设备的几何仍然不知道 就算是viewDidLoad也不知道
      //设定当前的缩放比例 以及 最大 最小比例
      scrollView.setZoomScale(imageScrollCurrentZoomScale, animated: false)
      //设定当前的偏移量 以更好的可视感
      scrollView.setContentOffset(imageScrollCurrentOffset, animated: false)
    }
  }
  
  
  
  
  //初始化一个CGRect(0,0,0,0)的UIImageView()
  private var imageView = UIImageView()
  private var aspectRatio: Double?
  
  var myImageItem: ImageMediaItem?{
    didSet{
      //这个属性在这里是通过prepareforsegue 设定的 所以此时的scrollView是nil（根据lifecycle）
      imageView.image = myImageItem!.image
      aspectRatio = myImageItem!.aspectRatio
      imageView.sizeToFit()
    }
  }
  
  private var imageScrollCurrentZoomScale: CGFloat {
    //由于调用时几何设定还未完成 使用设备的屏幕来计算
    //最小的缩放比例应该是能够把图片的一边刚好放到设备内 ? 为什么我的scrollView的宽度不等于设备的宽度
    let scaleToWidth = UIScreen.mainScreen().bounds.width / imageView.frame.width
   
    let scaleToHeight = UIScreen.mainScreen().bounds.height / imageView.frame.height
    
    if scaleToWidth < scaleToHeight{
      //图片的宽度更明显
      scrollView.minimumZoomScale = scaleToWidth
      scrollView.maximumZoomScale = scaleToHeight * 2
      return scaleToHeight
    }
    else {
      scrollView.minimumZoomScale = scaleToHeight
      scrollView.maximumZoomScale = scaleToWidth * 2
      return scaleToWidth
    }
    
  }
  
  private var imageScrollCurrentOffset: CGPoint {
    
    var x = scrollView.bounds.origin.x
    var y = scrollView.bounds.origin.y
    
    if imageView.frame.width > UIScreen.mainScreen().bounds.width{
      x = (imageView.frame.width - UIScreen.mainScreen().bounds.width) / 2
    }
    if imageView.frame.height > UIScreen.mainScreen().bounds.height{
      y = (imageView.frame.height - UIScreen.mainScreen().bounds.height) / 2
    }
    return CGPointMake(x, y)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    scrollView.addSubview(imageView)
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
