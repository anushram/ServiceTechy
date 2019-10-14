//
//  MyscheduleVC.swift
//  Technician
//
//  Created by K Saravana Kumar on 04/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import ObjectMapper

class MyscheduleVC: BaseVC,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate {
    
    
    
    //UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate
    
    private let cellIdentifier = "calendarCollectionViewCell"
    private let cellReuseIdentifier = "calendarReuseCollectionViewCell"
    
    @IBOutlet weak var calendarCollView: UICollectionView!
    
    @IBOutlet weak var dateMonth: UILabel!
    
    @IBOutlet weak var jobListTV: UITableView!
    
    @IBOutlet weak var selectedDateText: UILabel!
    
    var jobDetailArray = [OpenTicketsList]()
    
    var jobTicketArray = [String]()
    var jobTicketDict = [String: AnyObject]()
    
    var monthInfo: [SectionDateInformation:[CellDateInformation]] =  [SectionDateInformation:[CellDateInformation]]()
    
    var sectionInfo = [SectionDateInformation]()
    
    var currentDate = ""
    
    var currentDateIndex: Int = 0
    
    var segueIdentifier = ""
    
    
    @IBOutlet weak var joblistHeight: NSLayoutConstraint!
    @IBOutlet weak var jobListView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.segueIdentifier == "fromJobDetailViewToSchedule" {
            
        }else{
           setNavigationBarItem()
        }
        
        self.addNavigationBarTitleView(title: "Job Tickets", image: UIImage())
        // Do any additional setup after loading the view.
    
        var lastDate:Date
        
        var lastDateComponenet:Date
        
        currentDate = DateFormatManager.sharedInstance.getCurrentDateString()
        
        print(currentDate)
        
        //Calender
        
        let calendar = Calendar.current
        
        let firstDate = DateFormatManager.sharedInstance.getDateFromStringWithFormat(dateString: "01/01/2019", format: DateFormatManager.sharedInstance.kDateMonthYearFormat)
        
        let secondDate = DateFormatManager.sharedInstance.getDateFromStringWithFormat(dateString: "01/01/2020", format: DateFormatManager.sharedInstance.kDateMonthYearFormat)
        
        var date1 = DateFormatManager.sharedInstance.getDateFromStringWithFormat(dateString: DateFormatManager.sharedInstance.getStringFromDateWithFormat(date: calendar.startOfDay(for: firstDate! as Date) as NSDate, format: DateFormatManager.sharedInstance.kDateMonthYearFormat), format: DateFormatManager.sharedInstance.kDateMonthYearFormat)! as Date
        
        var date2 = DateFormatManager.sharedInstance.getDateFromStringWithFormat(dateString: DateFormatManager.sharedInstance.getStringFromDateWithFormat(date: calendar.startOfDay(for: secondDate! as Date) as NSDate, format: DateFormatManager.sharedInstance.kDateMonthYearFormat), format: DateFormatManager.sharedInstance.kDateMonthYearFormat)! as Date
        
        let components = calendar.dateComponents([.weekday], from: date1, to: date2)
        lastDate = date1
        lastDateComponenet = date1
        
        while date1 < date2 {
            
            let sectionDate = SectionDateInformation()
            
            let date1String = DateFormatManager.sharedInstance.getStringFromDateWithFormat(date: date1 as NSDate, format: DateFormatManager.sharedInstance.kDateMonthYearFormat)
            
            let valMonth = Calendar.current.dateComponents([.month], from: date1)
            let valYear = Calendar.current.dateComponents([.year], from: date1)
            
            sectionDate.dateInfo = date1String
            sectionDate.monthInfo = valMonth.month!
            sectionDate.yearInfo = valYear.year!
            
            lastDateComponenet = Calendar.current.date(byAdding: .month, value: 1, to: lastDateComponenet)!
            
            var cellDateInformationArray = [CellDateInformation]()
            
            while date1 < lastDateComponenet {
                
                
                
                let calldate :CellDateInformation = CellDateInformation()
                
                let val = Calendar.current.dateComponents([.weekday], from: date1)
                
                let valDay = Calendar.current.dateComponents([.day], from: date1)
                
                let valMonth = Calendar.current.dateComponents([.month], from: date1)
                
                print("weekDay",val.weekday!,valDay.day!,valMonth.month!)
                let date1String = DateFormatManager.sharedInstance.getStringFromDateWithFormat(date: date1 as NSDate, format: DateFormatManager.sharedInstance.kDateMonthYearFormat)
                
                date1 = Calendar.current.date(byAdding: .day, value: 1, to: date1)!
                
                
                calldate.dayInfo = valDay.day!
                calldate.dateInfo = date1String
                calldate.weekDayInfo = val.weekday!
                calldate.monthInfo = valMonth.month!
                
                if calldate.dateInfo == currentDate {
                    self.currentDateIndex = sectionInfo.count
                }
                
                cellDateInformationArray.append(calldate)
                
                //let componentsVal = calendar.dateComponents([.weekday], from: date1, to: date2)
                
            }
            
            
            
            //This things are used to show past day of the date
            let pastWeekDay = (cellDateInformationArray.first?.weekDayInfo)!
            print("test1",cellDateInformationArray.count)
            
            var beforeDate = DateFormatManager.sharedInstance.getDateFromStringWithFormat(dateString: (cellDateInformationArray.first?.dateInfo)!, format: DateFormatManager.sharedInstance.kDateMonthYearFormat)
            
            for _ in 1 ..< pastWeekDay {
                
                beforeDate = Calendar.current.date(byAdding: .day, value: -1, to: beforeDate! as Date)! as NSDate
                let valDay = Calendar.current.dateComponents([.day], from: beforeDate! as Date)
                print("00000")
                let calldateDummy :CellDateInformation = CellDateInformation()
                calldateDummy.dayInfo = valDay.day!
                cellDateInformationArray.insert(calldateDummy, at: 0)
                print("test2",cellDateInformationArray.count)
            }
            
            //end of past date
            
            sectionInfo.append(sectionDate)
            
            monthInfo.updateValue(cellDateInformationArray, forKey: sectionDate)
            //monthInfo[sectionDate] = cellDateInformationArray
            
            //date1 = Calendar.current.date(byAdding: .month, value: 1, to: date1)!
            
            //lastDateComponenet = dateFrom
            //lastDate = dateFrom
            
            
            
            
        }
        
        self.dateMonth.text = DateFormatManager.sharedInstance.getMonthAndYear(dateString: sectionInfo[0].dateInfo)
        
        DispatchQueue.main.async(execute: {
            
            //self.calendarCollView.reloadData()
            self.calendarCollView.scrollToItem(at: IndexPath.init(item: 0, section: self.currentDateIndex), at: .left, animated: true)
            self.dateMonth.text = DateFormatManager.sharedInstance.getMonthAndYear(dateString: self.sectionInfo[self.currentDateIndex].dateInfo)
        })
        
        print("count",monthInfo.count)
        let val  = currentDate.components(separatedBy: "/")
        self.getScheduledJobs(month: val[0], year: val[2])
        
        self.getJobListOfDate(date: currentDate)
        
    }
    
    //MARK: Collectionview Delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int{

        return sectionInfo.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        // offset by the number of months

        var obj = sectionInfo[section] as! SectionDateInformation

        let val = monthInfo[obj]

        print("bbbbb=",(val?.count)!)

        //monthInfo[]
        return (val?.count)!
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CalendarCollectionViewCell

        var obj = sectionInfo[indexPath.section] as! SectionDateInformation

        let val = monthInfo[obj]

        let objVal =  val![indexPath.row]

        if objVal.dateInfo == currentDate{

            let val  = currentDate.components(separatedBy: "/")

            if objVal.dayInfo == Int(val[1]){
                cell.dayText.backgroundColor = .blue
                cell.dayText.textColor = UIColor.white
            }else{
                cell.dayText.backgroundColor = UIColor.white
                cell.dayText.textColor = UIColor.black

            }

        }else{
            cell.dayText.backgroundColor = UIColor.white
            cell.dayText.textColor = UIColor.black

        }

        if objVal.dateInfo == "" {
            cell.isUserInteractionEnabled = false
            cell.dayText.text = String(objVal.dayInfo)
            cell.dayText.alpha = 0.3
            cell.dayText.textColor = UIColor.black
            //cell.isHidden = true

        }else {
            cell.isHidden = false
            cell.dayText.text = String(objVal.dayInfo)
            cell.isUserInteractionEnabled = true
            cell.dayText.alpha = 1.0
            //cell.dayText.textColor = UIColor.black

        }

        if self.jobTicketArray.contains(objVal.dateInfo) {
            
            let jobCount = self.jobTicketDict[objVal.dateInfo] as! Int
            
            if jobCount == 1 {
                cell.jobOne.backgroundColor = .blue
                cell.jobTwo.backgroundColor = .white
                cell.hiddenTextHeight.constant  = 0
                cell.jobMidText.updateConstraints()
                cell.jobMidText.layoutIfNeeded()
                //cell.jobTwo.isHidden = true
            }else if jobCount > 1 {
                cell.jobOne.backgroundColor = .green
                cell.jobTwo.backgroundColor = .red
                cell.hiddenTextHeight.constant  = 4
                cell.jobMidText.updateConstraints()
                cell.jobMidText.layoutIfNeeded()
                //cell.jobTwo.isHidden = false
                //cell.jobOne.isHidden = false
            }
            
        }else{
            cell.jobOne.backgroundColor = .white
            cell.jobTwo.backgroundColor = .white
        }

        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCollectionViewCell
        cell.dayText.backgroundColor = .blue
        cell.dayText.textColor = .white
        
        let obj = sectionInfo[indexPath.section]
        
        let val = monthInfo[obj]
        
        let objVal =  val![indexPath.row]
        self.currentDate = objVal.dateInfo
        print(objVal.dateInfo)
        self.selectedDateText.text = DateFormatManager.sharedInstance.getMonthDateYear(dateString: objVal.dateInfo)
        self.getJobListOfDate(date: objVal.dateInfo)
        self.calendarCollView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath){
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCollectionViewCell
        cell.dayText.backgroundColor = .white
        cell.dayText.textColor = .black
    }
    
//    @IBAction func mapViewAcrion(sender: UIButton){
//
//    }
    
    //MARK: UITableview Delegates & Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobDetailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "jobdate"
        var cell = self.jobListTV.dequeueReusableCell(withIdentifier: cellIdentifier) as? JobDateTVCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("JobDateTVCell", owner: self, options: nil)
            cell = nib![0] as? JobDateTVCell
        }
        
        let obj = jobDetailArray[indexPath.row]
        cell?.timeText.text = obj.scheduletime
        cell?.jobIDText.text = obj.jobid
        cell?.personNameText.text = "Contact Person: " + obj.clientname
        cell?.mobileNOText.text = "Mobile No: " + obj.mobile
        cell?.cityText.text = "City: " + obj.address
        cell?.desText.text = "City: " + obj.description
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let obj = jobDetailArray[indexPath.row]
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "fromscheduleTodetails", sender: obj)
        }
        
    }
    
    
    
    //MARK: Web Services
    
    func getJobListOfDate(date: String) {
        
        let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
        let param = ["request":["date":date]]
        NetworkManager.sharedInstance.getJobListOfDate(url: "/getTechdayjobresults", parameter: param, header: header) { (response) in
            
            switch response.result {
            case .success(_):
                
                print("values=",response.result.value!)
                if let responseValue = response.result.value as? NSDictionary {
                    
                    if let responseCode = responseValue["response"] as? NSDictionary {
                        
                        if let code = responseCode["code"] as? String {
                            
                            if code == "OK" {
                                
                                if let responseData = responseCode["data"] as? NSDictionary {
                                    
                                    if let responseResult = responseData["result"] as? NSDictionary {
                                        
                                        if let resultArray = responseResult["jobresult"] as? NSArray {
                                            
                                            let ticketList = Mapper<OpenTicketsList>().mapArray(JSONArray: resultArray as! [[String : Any]])
                                            print("vvv=",ticketList.count)
                                            self.jobDetailArray.removeAll()
                                            self.jobDetailArray.append(contentsOf: ticketList)
                                            
                                            if self.jobDetailArray.count == 0 {
                                                
                                                self.joblistHeight.constant = CGFloat(100 + 31)
                                                
                                            }else {
                                                
                                                self.joblistHeight.constant = CGFloat(((self.jobDetailArray.count * 100) + 31))
                                                
                                            }
                                            
                                            
                                            
                                            self.jobListView.updateConstraints()
                                            self.jobListView.layoutIfNeeded()
                                            DispatchQueue.main.async(execute: {
                                                
                                                self.jobListTV.reloadData()
                                                
                                            })
                                            
                                        }
                                        
                                        
                                        
                                    }
                                }
                                
                            }
                        }
                    }
                }
                
            case .failure(_): break
                
            }
            
        }
        
    }
    
    func getScheduledJobs(month: String,year: String) {
        let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
        let param = ["request":["month":month,"year":year]]
        NetworkManager.sharedInstance.getScheduledJobs(url: "/getTechmonthjobcount", parameter: param, header: header) { (response) in
            
            switch response.result {
            case .success(_):
                
                print("values=",response.result.value!)
                if let responseValue = response.result.value as? NSDictionary {
                    
                    if let responseCode = responseValue["response"] as? NSDictionary {
                        
                        if let code = responseCode["code"] as? String {
                            
                            if code == "OK" {
                                
                                if let responseData = responseCode["data"] as? NSDictionary {
                                    
                                    if let responseResult = responseData["result"] as? NSDictionary {
                                        
                                        if let dateList = responseResult["dateslist"] as? [String]{
                                            self.jobTicketArray.removeAll()
                                            self.jobTicketArray.append(contentsOf: dateList)
                                            
                                        }
                                        
                                        if let jobticketsDict = responseResult["jobresult"] as? NSArray{
                                            self.jobTicketDict.removeAll()
                                            for value in jobticketsDict {
                                                let jobDict = value as! [String: AnyObject]
                                                let jobDictKey = jobDict["date"] as! String
                                                let jobDictValue = Int(jobDict["count"] as! String)
                                                self.jobTicketDict[jobDictKey] = jobDictValue as AnyObject
                                                
                                            }
                                            
                                        }
                                        
                                        DispatchQueue.main.async(execute: {
                                            self.calendarCollView.reloadData()
                                            
                                        })
                                        
                                        
                                    }
                                }
                                
                            }
                        }
                    }
                }
                
            case .failure(_): break
                
            }
            
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        if let _ = scrollView as? UICollectionView {

        var value = Float((self.calendarCollView.contentOffset.x) / (self.calendarCollView.frame.size.width))

        value = floor(value)

        print("sssss=",value)

        let sectionValue = sectionInfo[Int(value)]

        //sectionValue.monthInfo

        self.dateMonth.text = DateFormatManager.sharedInstance.getMonthAndYear(dateString: sectionValue.dateInfo)
        self.getScheduledJobs(month: String(sectionValue.monthInfo), year: String(sectionValue.yearInfo))

        //        let dateFormatterGet = DateFormatter()
        //        dateFormatterGet.dateFormat = "dd/MM/yyyy"
        //
        //        let dateFormatterPrint = DateFormatter()
        //        //dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        //        dateFormatterPrint.dateFormat = "MMM, yyyy"
        //
        //        if let date = dateFormatterGet.date(from: sectionValue.dateInfo) {
        //            print(dateFormatterPrint.string(from: date))
        //
        //
        //        } else {
        //            print("There was an error decoding the string")
        //        }
        }

    }

    @IBAction func clickCurrentAction(sender: UIButton){

        var indexValue = 0


        for (index,value) in sectionInfo.enumerated() {


            let val = monthInfo[value]

            for valueMonth in val! {

                if valueMonth.dateInfo == currentDate {

                    indexValue = index

                }

            }

        }

        let collOffset = Float(indexValue) * Float(self.calendarCollView.frame.size.width)

        self.dateMonth.text = DateFormatManager.sharedInstance.getMonthAndYear(dateString: sectionInfo[indexValue].dateInfo)

        self.calendarCollView.scrollToItem(at: IndexPath.init(item: 0, section: indexValue), at: .left, animated: true)

    }
    
    @IBAction func mapViewAction(sender: UIButton){
        
        if jobDetailArray.count != 0 {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "jobticketmap", sender: self)
            }
            
        }
        
        //jobticketmap
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "jobticketmap" {
            
            let view = segue.destination as! JobMapViewVC
            view.mapArray = jobDetailArray
        }else if segue.identifier == "fromscheduleTodetails" {
            
            let view = segue.destination as! TicketDetailsView
            
            view.jobDetailObjects = sender as! OpenTicketsList
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
