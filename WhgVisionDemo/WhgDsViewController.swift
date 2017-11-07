//
//  WhgDsViewController.swift
//  WhgVisionDemo
//
//  Created by hg w on 2017/10/20.
//  Copyright © 2017年 whg. All rights reserved.
//

import UIKit

class WhgDsViewController: UIViewController {
    var tableView: UITableView?
    let dataArr = ["人脸识别", "特征识别", "文字识别", "实时监测Face", "实时动态添加"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight - 0), style: .plain)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.estimatedRowHeight = 0
        self.tableView?.estimatedSectionFooterHeight = 0
        self.tableView?.estimatedSectionHeaderHeight = 0
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier:"reuse")
        
        self.view.addSubview(self.tableView!)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(NSNumber.init(value: 1), forKey: "orientation")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension WhgDsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse")
        cell?.textLabel?.text = self.dataArr[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str = self.dataArr[indexPath.row]
        
        switch str {
        case "人脸识别":
            self.navigationController?.pushViewController(WhgDSFaceViewController.init(type: .DSDetectionTypeFace), animated: true)
        case "特征识别":
            self.navigationController?.pushViewController(WhgDSFaceViewController.init(type: .DSDetectionTypeLandmark), animated: true)
        case "文字识别":
            self.navigationController?.pushViewController(WhgDSFaceViewController.init(type: .DSDetectionTypeTextRectangles), animated: true)
        case "实时监测Face":
            self.navigationController?.pushViewController(WhgCameraCaptureController.init(type: .DSDetectionTypeFaceRectangles), animated: true)
        default:
            self.navigationController?.pushViewController(WhgDSFaceViewController.init(type: .DSDetectionTypeFaceHat), animated: true)
        }
    }
    
    
}
