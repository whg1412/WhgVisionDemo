//
//  WhgCameraCaptureController.swift
//  WhgVisionDemo
//
//  Created by hg w on 2017/10/26.
//  Copyright © 2017年 whg. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class WhgCameraCaptureController: UIViewController {
    
    var captureSession: AVCaptureSession?
    var videoDevice: AVCaptureDevice?
    var videoInput: AVCaptureDeviceInput?
    var dataOutput: AVCaptureVideoDataOutput?
    var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var layers:[Any] = []
    var hats: [UIImageView] = []
    
    let detectionType: DSDetectionType!
    
    init(type: DSDetectionType) {
        detectionType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initCapture()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(NSNumber.init(value: 3), forKey: "orientation")
    }
    
    // TODO: 初始化相关内容
    func initCapture() {
        self.addSession()
        self.captureSession?.beginConfiguration()
        
        self.addVideo()
        if self.captureSession != nil {
            self.addPreviewLayer()
            self.captureSession?.commitConfiguration()
            self.captureSession?.startRunning()
        }

        
    }
    
    // TODO: 初始化session
    func addSession() {
        self.captureSession = AVCaptureSession.init()
        // 设置分辨率
        if captureSession?.canSetSessionPreset(.high) == true {
            captureSession?.sessionPreset = .high
        }
    }
    
    // TODO: 初始化摄像头设备
    func addVideo() {
        self.videoDevice = self.deviceWithMediaType(mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back)
        
        self.addVideoInput()
        self.addDataOutput()
    }
    
    // TODO: 初始化输入
    func addVideoInput() {
        do {
            try self.videoInput = AVCaptureDeviceInput.init(device: self.videoDevice!)
            
            // 将视频输入对象添加到会话
            if self.videoInput != nil {
                if self.captureSession?.canAddInput(self.videoInput!) == true {
                    self.captureSession?.addInput(self.videoInput!)
                }
            }
            
        } catch {
            
        }
    }
    
    // TODO: 初始化输出
    func addDataOutput() {
        self.dataOutput = AVCaptureVideoDataOutput.init()
        self.dataOutput?.setSampleBufferDelegate(self, queue: DispatchQueue.init(label: "CameraCaptureSampleBufferDelegateQueue"))
        
        if self.dataOutput != nil {
           self.captureSession?.addOutput(self.dataOutput!)
            let captureConnection = dataOutput?.connection(with: AVMediaType.video)
            if captureConnection?.isVideoOrientationSupported == true {
                captureConnection?.videoOrientation = AVCaptureVideoOrientation.portrait
            }
            
            // 视频稳定设置
            if captureConnection?.isVideoStabilizationSupported == true {
                captureConnection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
            
            // 设置输出方向
            captureConnection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        }
    }
    
    // TODO: 添加预览视图
    func addPreviewLayer() {
        // 通过绘画创建预览层
        self.captureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: self.captureSession!)
        self.captureVideoPreviewLayer?.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.size.height, height: self.view.bounds.size.width)
        
        // 修改拍摄尺寸
        self.captureVideoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.captureVideoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        
        // 显示
        let layer = self.view.layer
        layer.masksToBounds = true
        self.view.layoutIfNeeded()
        layer.addSublayer(self.captureVideoPreviewLayer!)
        
    }
    
    // TODO: 获取设备
    func deviceWithMediaType(mediaType: AVMediaType, position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devicesSessions = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: mediaType, position: position)
        let devices = devicesSessions.devices
        var captureDevice = devices.first
        
        for device in devices {
            if (device.position == position) {
                captureDevice = device
                break
            }
        }
        return captureDevice
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WhgCameraCaptureController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let BufferRef: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let detectFaceRequest = VNDetectFaceRectanglesRequest.init()
        let detectFaceRequestHandler = VNImageRequestHandler.init(cvPixelBuffer: BufferRef, options: [:])
        
        do {
            try detectFaceRequestHandler.perform([detectFaceRequest])
            let results = detectFaceRequest.results
            
            DispatchQueue.main.async {
                if (self.detectionType == DSDetectionType.DSDetectionTypeFaceRectangles) {
                    // 移除矩形
                    for layer in self.layers {
                        let caLayer = layer as! CALayer
                        caLayer.removeFromSuperlayer()
                    }
                }else if(self.detectionType == DSDetectionType.DSDetectionTypeFaceHat) {
                    // 移除帽子
                    for imageV in self.hats {
                        imageV.removeFromSuperview()
                    }
                }
                
                self.layers.removeAll()
                self.hats.removeAll()
                
                // 原点为左下角
                for observation in results ?? [] {
                    let obvi = observation as! VNFaceObservation
                    let oldRect = obvi.boundingBox
                    print(oldRect)
                    let w = oldRect.size.width * self.view.bounds.size.width
                    let h = oldRect.size.height * self.view.bounds.size.height
                    let x = oldRect.origin.x * self.view.bounds.size.width
                    let y = self.view.bounds.size.height - (oldRect.origin.y * self.view.bounds.size.height) - h
                    
                    // 添加矩形
                    let rect = CGRect.init(x: x, y: y, width: w, height: h)
                    let testLayer = CALayer.init()
                    testLayer.borderWidth = 2
                    testLayer.cornerRadius = 3
                    testLayer.borderColor = UIColor.red.cgColor
                    testLayer.frame = rect
                    
                    self.layers.append(testLayer)
                    
                    // 添加帽子
                    let hatWidth = w
                    let hatHeight = h
                    let hatX = rect.origin.x - hatWidth / 4 + 3
                    let hatY = rect.origin.y -  hatHeight
                    let hatRect = CGRect.init(x: hatX, y: hatY, width: hatWidth, height: hatHeight)
                    
                    //矩形
                    for layer in self.layers {
                        let ca = layer as! CALayer
                        self.view.layer.addSublayer(ca)
                    }
                }
            }
        }catch {
            
        }
        
        
    }
}
