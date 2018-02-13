//
//  ViewController.swift
//  NetworkViewer
//
//  Created by Takahiro Kaneko on 2018/02/09.
//  Copyright © 2018年 TK. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mailAddress: UILabel!
    @IBOutlet weak var selfIntro: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initialize()
    }
    
    private func initialize() {
        [name, mailAddress, selfIntro, date].forEach {
            $0.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {
    private func executeGetUserApi() {
        let network = NetworkLayer()
        
        network.setStartHandler {()->() in
            SVProgressHUD.show(withStatus: "Loading...")
        }
        network.setErrorHandler {(error: NSError)->() in
            // 通信失敗時
            SVProgressHUD.dismiss()
            print("通信に失敗しました")
        }
        network.setFinishHandler {(result: Any?)->() in
            // 通信成功時 (※ローディングポップアップの挙動を確認するためにワザと待たせています)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                SVProgressHUD.dismiss()
                
                guard let data = result as? UserModel else { return }
                // サーバーから取得した値を各パラメータにセットし画面へ表示
                self.name.text = data.name
                self.mailAddress.text = data.email
                self.selfIntro.text = data.introduction
                self.date.text = data.date
            }
        }
        
        // パラメータセット
        let userId = 1
        // API実行
        network.requestApi(api: .profile(userId), parameters: nil, headers: nil)
    }
}
