//
//  ViewController.swift
//  LEEAlertSwiftDemo
//
//  Created by 李响 on 2021/1/9.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let alert = LEEAlert.alert()
        _ = alert.config
        .leeTitle("标题")
        .leeContent("内容")
        .leeAction("确认", {
            print("点击取消")
        })
        .leeShow()
    }
}

