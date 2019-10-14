//
//  PartsNumberView.swift
//  Technician
//
//  Created by K Saravana Kumar on 20/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
protocol PartsNumberDidSelectDelegate{
    func sendObjectID(pickedString: PartsCostItem, cell: PartsCostTVC)
}

class PartsNumberView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableview:UITableView!
    
    var delegate: PartsNumberDidSelectDelegate?
    
    var cell: PartsCostTVC!
    
    class func instanceFromNib() -> PartsNumberView {
        
        return UINib(nibName: "PartsNumberView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PartsNumberView
        
    }
    
    override func awakeFromNib() {
        //searchBar.becomeFirstResponder()
        tableview.register(UINib.init(nibName: "PartsNumberTableViewCell", bundle: nil), forCellReuseIdentifier: "partsnumber")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return Singleton.sharedInstance.partsCostObjects.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 30
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        
        let cellIdentifier = "partsnumber"
        var cell = self.tableview.dequeueReusableCell(withIdentifier: cellIdentifier) as? PartsNumberTableViewCell
        // SwipeLeftTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("PartsNumberTableViewCell", owner: self, options: nil)
            cell = nib![0] as? PartsNumberTableViewCell
        }
        let obj = Singleton.sharedInstance.partsCostObjects[indexPath.row]
        cell?.partsNoText.text = obj.itemid
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let obj = Singleton.sharedInstance.partsCostObjects[indexPath.row]
        delegate?.sendObjectID(pickedString: obj, cell: cell)
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
