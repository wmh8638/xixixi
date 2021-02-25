//
//  ViewController.swift
//  xixixi
//
//  Created by SGMWH on 2021/2/24.
//

import UIKit
import Alamofire
import ReactiveCocoa
import SnapKit
import SwiftyJSON
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchTimer(timeInterval: 5) { (timer) in
            self.getTestApi()
        }
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .green
        btn.setTitle("历史记录", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            let vc = HistoryRecord.init()
            let nav = UINavigationController.init(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(44)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        let scrollView = UIScrollView.init()
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(btn.snp_bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        let content = UIView.init()
        scrollView.addSubview(content)
        content.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.left.right.bottom.equalToSuperview()
        }
        
        let lbl = UILabel.init()
        lbl.numberOfLines = 0
        content.addSubview(lbl)
        lbl.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        
        if  UserDefaults.standard.object(forKey: "testxixixi") != nil {
            let arr = UserDefaults.standard.object(forKey: "testxixixi") as! NSArray
            let dic = arr.lastObject as! NSDictionary
            lbl.text = String.init(format: "时间：%@，内容：%@", dic["time"] as! CVarArg,dic["content"] as! CVarArg)
        }
        
    }
    /// GCD定时器倒计时⏳
    ///   - timeInterval: 循环间隔时间
    ///   - repeatCount: 重复次数
    ///   - handler: 循环事件, 闭包参数： 1. timer， 2. 剩余执行次数
    public func DispatchTimer(timeInterval: Double, handler:@escaping (DispatchSourceTimer?)->())
    {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer.schedule(wallDeadline: .now(), repeating: timeInterval)
        timer.setEventHandler(handler: {
            DispatchQueue.main.async {
                handler(timer)
            }
        })
        timer.resume()
    }
    func getTestApi(){
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd' at 'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        print("时间 = \(strNowTime)")
        let weatherUrl:String = "https://api.github.com/"
        Alamofire.request(weatherUrl,method:.get,parameters:[:],encoding: URLEncoding.default).responseJSON { (response) in
                switch response.result {
                case .success(let json ):
                    let jsonDic = json as? NSDictionary
                    let jsonString = JSON(jsonDic! as NSDictionary)
                    print(jsonString.rawString()!)
                    let dic = ["time":strNowTime,"content":jsonString.rawString()]
                    if  UserDefaults.standard.object(forKey: "testxixixi") == nil {
                        let arr = NSMutableArray.init()
                        arr.add(dic)
                        UserDefaults.standard.setValue(arr, forKey: "testxixixi")
                        UserDefaults.standard.synchronize()
                    }else{
                        let arr = UserDefaults.standard.object(forKey: "testxixixi") as! NSArray
                        let tempArr = NSMutableArray.init(array: arr)
                        tempArr.add(dic)
                        UserDefaults.standard.setValue(tempArr, forKey: "testxixixi")
                        UserDefaults.standard.synchronize()
                    }
                    
                    
                    break
                case .failure(let error):
                    print("error:\(error)")
                    break
                }
            }
        }
}

