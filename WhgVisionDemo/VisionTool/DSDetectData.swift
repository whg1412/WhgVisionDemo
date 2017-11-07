//
//  DSDetectData.swift
//  WhgVisionDemo
//
//  Created by hg w on 2017/10/20.
//  Copyright © 2017年 whg. All rights reserved.
//

import Foundation
import Vision

class DSDetectFaceData: NSObject {
    var observation: VNFaceObservation?
    var allPoints: [Any]? = []
    
    // 脸部轮廓
    var faceContour: VNFaceLandmarkRegion2D?
    // 左眼,右眼
    var leftEye: VNFaceLandmarkRegion2D?
    var rightEye: VNFaceLandmarkRegion2D?
    // 鼻子,鼻梁
    var nose: VNFaceLandmarkRegion2D?
    var noseCrest: VNFaceLandmarkRegion2D?
    var medianLine: VNFaceLandmarkRegion2D?
    // 外唇, 内唇
    var outerLips: VNFaceLandmarkRegion2D?
    var innerLips: VNFaceLandmarkRegion2D?
    // 左右眉毛
    var leftEyebrow: VNFaceLandmarkRegion2D?
    var rightEyebrow: VNFaceLandmarkRegion2D?
    // 瞳孔
    var leftPupil: VNFaceLandmarkRegion2D?
    var rightPupil: VNFaceLandmarkRegion2D?
    
    //重写父类的方法
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        //没有调用super，将父类的代码完全覆盖，不会崩溃
        switch key {
        case "faceContour":
            self.faceContour = value as? VNFaceLandmarkRegion2D
        case "leftEye":
            self.leftEye = value as? VNFaceLandmarkRegion2D
        case "rightEye":
            self.rightEye = value as? VNFaceLandmarkRegion2D
        case "nose":
            self.nose = value as? VNFaceLandmarkRegion2D
        case "noseCrest":
            self.noseCrest = value as? VNFaceLandmarkRegion2D
        case "medianLine":
            self.medianLine = value as? VNFaceLandmarkRegion2D
        case "outerLips":
            self.outerLips = value as? VNFaceLandmarkRegion2D
        case "innerLips":
            self.innerLips = value as? VNFaceLandmarkRegion2D
        case "leftEyebrow":
            self.leftEyebrow = value as? VNFaceLandmarkRegion2D
        case "rightEyebrow":
            self.rightEyebrow = value as? VNFaceLandmarkRegion2D
        case "leftPupil":
            self.leftPupil = value as? VNFaceLandmarkRegion2D
        case "rightPupil":
            self.rightPupil = value as? VNFaceLandmarkRegion2D
            
        default:
            break
        }
    }
}

class DSDetectData: NSObject {
    var faceAllRect: [Any]? = []
    var textAllRect: [Any]? = []
    var facePoints: [Any]? = []
}



