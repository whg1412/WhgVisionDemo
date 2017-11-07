//
//  WhgDSFaceViewController.swift
//  WhgVisionDemo
//
//  Created by hg w on 2017/10/20.
//  Copyright © 2017年 whg. All rights reserved.
//

import UIKit
import Vision

class WhgDSFaceViewController: UIViewController {

    let detectionType: DSDetectionType!
    init(type: DSDetectionType) {
        detectionType = type
        print(detectionType)
        super.init(nibName: nil, bundle: nil)
        
    }
    

    
    lazy var showImageView: UIImageView = {
       let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 64, width: screenWidth, height: screenWidth))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.yellow
        return imageView
    }()
    
    lazy var pickerVc: UIImagePickerController = {
        let imagePicker = UIImagePickerController.init()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        return imagePicker
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.showImageView)
        self.view.backgroundColor = UIColor.white

        let time: TimeInterval = 0.2
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            self.present(self.pickerVc, animated: true, completion: nil)
        }
    }
    
    // TODO: 图片压缩到指定大小
    func scaleImage(width: CGFloat, image: UIImage) -> UIImage {
        let height = image.size.height * width / image.size.width
        UIGraphicsBeginImageContext(CGSize.init(width: width, height: height))
        image.draw(in: CGRect.init(x: 0, y: 0, width: width, height: height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let tempData = UIImageJPEGRepresentation(result!, 0.5)
        return UIImage.init(data: tempData!)!
        
    }
    
    // TODO: 画图
    func drawImage(image: UIImage, observation: VNFaceObservation, pointArray: [Any]) -> UIImage {
        var sourceImage = image
        
        // 遍历所有特征
        for landmarks2D in pointArray {
            let landMark = landmarks2D as! VNFaceLandmarkRegion2D
            var points:[CGPoint] = []
            for i in 0..<landMark.pointCount {
                let point = landMark.normalizedPoints[i]
                let rectWidth = sourceImage.size.width * observation.boundingBox.size.width
                let rectHeight = sourceImage.size.height * observation.boundingBox.size.height
                let p = CGPoint.init(x: point.x * rectWidth + observation.boundingBox.origin.x * sourceImage.size.width, y: observation.boundingBox.origin.y * sourceImage.size.height + point.y * rectHeight)
                points.append(p)
            }
            
            UIGraphicsBeginImageContextWithOptions(sourceImage.size, false, 1);
            let context = UIGraphicsGetCurrentContext();
            UIColor.green.set()
            context!.setLineWidth(2);
            
            // 设置翻转
            context!.translateBy(x: 0, y: sourceImage.size.height)
            context!.scaleBy(x: 1.0, y: -1.0)
            
            // 设置线类型
            context!.setLineJoin(CGLineJoin.round)
            context!.setLineCap(CGLineCap.round)
            
            // 设置抗锯齿
            context!.setShouldAntialias(true)
            context!.setAllowsAntialiasing(true)
            
            // 绘制
            let rect = CGRect.init(x: 0, y: 0, width: sourceImage.size.width, height: sourceImage.size.height)
            context!.draw(sourceImage.cgImage!, in: rect, byTiling: false)
            context!.addLines(between: points)
            context!.drawPath(using: CGPathDrawingMode.stroke)
            
            // 结束绘制
            sourceImage = UIGraphicsGetImageFromCurrentImageContext()!;
            UIGraphicsEndImageContext();
        }
        return sourceImage
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WhgDSFaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // TOOD: 图片选择完
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image: UIImage? = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.pickerVc.dismiss(animated: true, completion: nil)
        self.detectFace(image: image!)
    }
    
    // TODO: 取消选择图片
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerVc.dismiss(animated: true, completion: nil)
        
    }
    
    // TODO: 检测照片
    func detectFace(image: UIImage) {
        let localImage = self.scaleImage(width: UIScreen.main.bounds.width, image: image)
        self.showImageView.image = localImage
        var frame = self.showImageView.frame
        frame.size = localImage.size
        self.showImageView.frame = frame
        
        DSVisionTool.detectImageWithType(type: self.detectionType, image: localImage) { (detectData) in
            switch self.detectionType {
            case .DSDetectionTypeLandmark:
                for faceData in detectData.facePoints ?? [] {
                let data = faceData as! DSDetectFaceData
                    self.showImageView.image = self.drawImage(image: self.showImageView.image!, observation: data.observation!, pointArray: data.allPoints!)
                    
            }
             
            default:
                break
            
        }
        
    }
    
}

}
