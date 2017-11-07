//
//  ViewController.swift
//  WhgVisionDemo
//
//  Created by hg w on 2017/10/20.
//  Copyright © 2017年 whg. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

enum DSDetectionType {
    case DSDetectionTypeFace //人脸识别
    case DSDetectionTypeLandmark // 特征识别
    case DSDetectionTypeTextRectangles // 文字识别
    case DSDetectionTypeFaceHat
    case DSDetectionTypeFaceRectangles
}

class ViewController: UIViewController {
    
    let button = UIButton.init(type: .system)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(NSNumber.init(value: 1), forKey: "orientation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        button.frame = CGRect.init(x: screenWidth/2-50, y: screenHeight/2-20, width: 100, height: 40)
        button.setTitle("点击开始", for: .normal)
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    
    @objc func clickButton() {
        //self.present(WhgDsViewController(), animated: true, completion: nil)
        self.navigationController?.pushViewController(WhgDsViewController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

