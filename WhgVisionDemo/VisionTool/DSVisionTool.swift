//
//  DSVisionTool.swift
//  WhgVisionDemo
//
//  Created by hg w on 2017/10/20.
//  Copyright © 2017年 whg. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Vision

typealias detectImageHandler = (_ detectData: DSDetectData) -> Void
typealias CompletionHandler = (_ request: VNRequest, _ error: Error) -> Void

class DSVisionTool {
    
    // TODO: 识别图片
    static func detectImageWithType(type: DSDetectionType, image: UIImage, complete: @escaping detectImageHandler) {
        // 转换CIImage
        let convertImage: CIImage? = CIImage.init(image: image)
        
        // 创建处理requestHandler
        let detectRequestHandler = VNImageRequestHandler.init(ciImage: convertImage!, options: [:])
        
        // 创建基本请求
        var detectRequest = VNImageBasedRequest.init()
        
        // 设置回调
        let completionHandler: VNRequestCompletionHandler = { (request, error) in
            let observations = request.results;
            self.handleImageWithType(type: type, image: image, observations: observations!, complete: complete)
        }
        
        // 根据类型设置请求
        switch type {
        case .DSDetectionTypeFace:
            detectRequest = VNDetectFaceRectanglesRequest.init(completionHandler: completionHandler)
        case .DSDetectionTypeLandmark:
            detectRequest = VNDetectFaceLandmarksRequest.init(completionHandler: completionHandler)
        case .DSDetectionTypeTextRectangles:
            detectRequest = VNDetectTextRectanglesRequest.init(completionHandler: completionHandler)
        default:
            break
        }
        
        // 发送识别请求
        do {
          try detectRequestHandler.perform([detectRequest])
        } catch {
            
        }
    }

    // TODO: 处理识别数据
    static func handleImageWithType(type: DSDetectionType, image: UIImage, observations: [Any], complete: detectImageHandler) {
        switch type {
        case .DSDetectionTypeFace:
            break
        case .DSDetectionTypeLandmark:
            self.faceLandmarks(observations: observations, image: image, complete: complete)
            break
        case .DSDetectionTypeTextRectangles:
            break
        default:
            break
        }
    }
    
    // TODO: 人脸特征回调
    static func faceLandmarks(observations: [Any], image: UIImage, complete: detectImageHandler) {
        let detectData = DSDetectData.init()
        
        for observation in observations {
            let obvr = observation as! VNFaceObservation
            
            // 创建特征存储对象
            let detectFaceData = DSDetectFaceData.init()
            
            // 获取细节特征
            let landmarks = obvr.landmarks
            let keyArr = ["faceContour", "leftEye", "rightEye", "nose", "noseCrest", "medianLine", "outerLips", "innerLips", "leftEyebrow", "rightEyebrow", "leftPupil", "rightPupil"]
            for i in 0..<keyArr.count {
                let key = keyArr[i]
                // 得到对应具体细节
                let region2D = landmarks?.value(forKey: key)
                detectFaceData.allPoints?.append(region2D!)
                detectFaceData.setValue(region2D!, forKey: key)
            }
            detectFaceData.observation = obvr
            detectData.facePoints?.append(detectFaceData)
        }
            complete(detectData)
        
    }
    
}
