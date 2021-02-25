//
//  historyRecord.swift
//  xixixi
//
//  Created by SGMWH on 2021/2/25.
//

import UIKit

class HistoryRecord: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryRecordCell", for: indexPath) as! HistoryRecordCell
        cell.backgroundColor = UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)
        let dic = self.dataSource[indexPath.row] as! NSDictionary
        cell.title.text = String.init(format: "时间：%@，内容：%@", dic["time"] as! CVarArg,dic["content"] as! CVarArg)
        return cell
    }
    
    var tableView :UITableView?
    
    var dataSource : NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView.init(frame: .zero, style: .plain)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        self.tableView?.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalToSuperview()
        })
        let bundle = Bundle(for: HistoryRecordCell.self)
        let nib = UINib(nibName: "HistoryRecordCell", bundle: bundle)
        self.tableView?.register(nib, forCellReuseIdentifier: "HistoryRecordCell")
        if  UserDefaults.standard.object(forKey: "testxixixi") != nil {
            let arr = UserDefaults.standard.object(forKey: "testxixixi") as! NSArray
            self.dataSource = arr.reversed() as NSArray
            self.tableView?.reloadData()
        }
    }
    
}
