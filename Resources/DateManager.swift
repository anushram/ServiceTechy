//
//  DateManager.swift
//  CalendarView
//
//  Created by K Saravana Kumar on 20/06/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit

class DateFormatManager: NSObject {

static let sharedInstance = DateFormatManager()

var dateFormatter: DateFormatter!

let kYearMonthDayFormat: String = "yyyy-MM-dd"
let kFullDateWithTimeZoneIdFormat: String = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
let kFullDateWithTimeZoneOffsetFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
let kMonthDayYearTimeFormat: String = "MMMM d, yyyy H:mm a"
let kShortMonthDayYearFormat: String = "EEEE MMM dd, yyyy"
let kDateMonthYearFormat: String = "MM/dd/yyyy"
let kMonthDateYearFormat : String = "MM/dd/yyyy"
//"EEEE, MMMM dd, yyyy"

let kEnUsLocaleIdentifier: String = "en_US_POSIX"

func getDateFormatterWithFormat(format: String) -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.locale = NSLocale(localeIdentifier: kEnUsLocaleIdentifier) as Locale?
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    return dateFormatter
}

func convertDistanceFromDate(dateString: String) -> String {
    if dateString.count == 0 {
        
        return ""
        
    }
    else{
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        dateFormater.locale = Locale(identifier: "en_US_POSIX")
        dateFormater.timeZone = TimeZone(abbreviation: "IST")
        //dateFormater.timeZone = TimeZone.current
        //dateFormater.timeZone = TimeZone(abbreviation: "GMT")
        let dateValue = dateFormater.date(from: dateString)!
        let dateValueString = dateFormater.string(from: dateValue)
        
        let dateFormaterCurrent = DateFormatter()
        dateFormaterCurrent.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        dateFormater.locale = Locale(identifier: "en_US_POSIX")
        dateFormater.timeZone = TimeZone(abbreviation: "IST")
        //dateFormaterCurrent.timeZone = TimeZone.current
        //dateFormaterCurrent.timeZone = TimeZone(abbreviation: "GMT")
        let date = dateFormaterCurrent.date(from: dateValueString)!
        
        let currentDate = Date()
        
        let dateFormaterNow = DateFormatter()
        dateFormaterNow.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        dateFormater.locale = Locale(identifier: "en_US_POSIX")
        dateFormaterNow.timeZone = TimeZone(abbreviation: "IST")
        let dateValueStringNow = dateFormaterNow.string(from: currentDate)
        //dateFormaterCurrent.timeZone = TimeZone.current
        //dateFormaterCurrent.timeZone = TimeZone(abbreviation: "GMT")
        let nowDate = dateFormaterCurrent.date(from: dateValueStringNow)!
        
        //        //let currentTimeZone = TimeZone.current
        //        let currentTimeZone = TimeZone(abbreviation: "GMT")
        //
        //        let nowTimeZone = TimeZone(abbreviation: "GMT")
        //
        //        //let nowTimeZone = TimeZone.current
        //
        //        let currentISTOffset = currentTimeZone?.secondsFromGMT(for: currentDate)
        //
        //        let nowGMTOffset = nowTimeZone?.secondsFromGMT(for: currentDate)
        //
        //        let interval = Double(nowGMTOffset! - currentISTOffset!) as TimeInterval
        //
        //        let nowDate = Date.init(timeInterval: interval, since: currentDate)
        
        //        let dateFormaterModified = DateFormatter()
        //        dateFormaterModified.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        //        dateFormaterModified.locale = Locale(identifier: "en_US_POSIX")
        //        //dateFormaterModified.timeZone = TimeZone.current
        //        dateFormaterModified.timeZone = TimeZone(abbreviation: "GMT")
        //        print("bbjnnb=",TimeZone.current)
        //        //dateFormaterModified.timeZone = TimeZone.current
        //        //TimeZone.current.identifier
        let gregorianCalendar = Calendar.init(identifier: .gregorian)
        
        let components1 = gregorianCalendar.dateComponents([.year, .month,.weekOfMonth, .day, .hour, .minute, .second], from: date, to: nowDate)
        if components1.year == 0 {
            
            if components1.month == 0 {
                
                if components1.weekOfMonth == 0 {
                    
                    if components1.day == 0 {
                        
                        if components1.hour == 0 {
                            
                            if components1.minute == 0 {
                                
                                if components1.second == 0 {
                                    
                                    return ""
                                    
                                }
                                else {
                                    return String(describing:abs((components1.second)!)) + " " + "seconds ago"
                                }
                                
                            }
                            else {
                                return String(describing: abs((components1.minute)!)) + " " + " minutes ago"
                            }
                            
                        }
                        else {
                            return String(describing: abs((components1.hour)!)) + " " + "hours ago"
                        }
                        
                    }
                    else {
                        return String(describing: abs((components1.day)!)) + " " + "days ago"
                    }
                    
                }
                else {
                    return String(describing: abs((components1.weekOfMonth)!)) + " " + "weeks ago"
                }
                
            }
            else {
                return String(describing: abs((components1.month)!)) + " " + "months ago"
            }
            
        }
        else {
            return String(describing: abs((components1.year)!)) + " " + "years ago"
        }
        
        //        let dateFormatter = DateFormatter()
        //        let tempLocale = dateFormatter.locale // save locale temporarily
        //        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        //        let date = dateFormatter.date(from: dateString)!
        //        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        //        dateFormatter.locale = tempLocale // reset the locale
        //        let dateString = dateFormatter.string(from: date)
        
        //        let calendar = Calendar.current
        //
        //        let year = calendar.component(.year, from: date)
        //        let month = calendar.component(.month, from: date)
        //        let day = calendar.component(.day, from: date)
    }
}


func convertSecondsFromDate(dateString: String) -> String {
    if dateString.count == 0 {
        
        return ""
        
    }
    else{
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        dateFormater.locale = Locale(identifier: "en_US_POSIX")
        //dateFormater.timeZone = TimeZone(abbreviation: "GMT")
        dateFormater.timeZone = TimeZone(abbreviation: "MST")
        let dateValue = dateFormater.date(from: dateString)!
        let dateValueString = dateFormater.string(from: dateValue)
        
        let dateFormaterCurrent = DateFormatter()
        dateFormaterCurrent.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        dateFormater.locale = Locale(identifier: "en_US_POSIX")
        //dateFormater.timeZone = TimeZone(abbreviation: "GMT")
        dateFormaterCurrent.timeZone = TimeZone(abbreviation: "GMT")
        let date = dateFormaterCurrent.date(from: dateValueString)!
        
        let currentDate = Date()
        
        let currentTimeZone = TimeZone(abbreviation: "GMT")
        
        let nowTimeZone = TimeZone.current
        
        let currentISTOffset = currentTimeZone?.secondsFromGMT(for: currentDate)
        
        let nowGMTOffset = nowTimeZone.secondsFromGMT(for: currentDate)
        
        let interval = Double(nowGMTOffset - currentISTOffset!) as TimeInterval
        
        let nowDate = Date.init(timeInterval: interval, since: currentDate)
        
        let dateFormaterModified = DateFormatter()
        dateFormaterModified.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        dateFormaterModified.locale = Locale(identifier: "en_US_POSIX")
        dateFormaterModified.timeZone = TimeZone(abbreviation: "GMT")
        print("bbjnnb=",TimeZone.current)
        //dateFormaterModified.timeZone = TimeZone.current
        //TimeZone.current.identifier
        let gregorianCalendar = Calendar.init(identifier: .gregorian)
        
        let components1 = gregorianCalendar.dateComponents([.year, .month,.weekOfMonth, .day, .hour, .minute, .second], from: date, to: nowDate)
        if components1.year == 0 {
            
            if components1.month == 0 {
                
                if components1.weekOfMonth == 0 {
                    
                    if components1.day == 0 {
                        
                        if components1.hour == 0 {
                            
                            if components1.minute == 0 {
                                
                                if components1.second == 0 {
                                    
                                    return ""
                                    
                                }
                                else {
                                    return String(describing:abs((components1.second)!)) + " " + "seconds ago"
                                }
                                
                            }
                            else {
                                return String(describing: abs((components1.minute)!)) + " " + " minutes ago"
                            }
                            
                        }
                        else {
                            return String(describing: abs((components1.hour)!)) + " " + "hours ago"
                        }
                        
                    }
                    else {
                        return String(describing: abs((components1.day)!)) + " " + "days ago"
                    }
                    
                }
                else {
                    return String(describing: abs((components1.weekOfMonth)!)) + " " + "weeks ago"
                }
                
            }
            else {
                return String(describing: abs((components1.month)!)) + " " + "months ago"
            }
            
        }
        else {
            return String(describing: abs((components1.year)!)) + " " + "years ago"
        }
        
        
        var secValue = components1.year! * 31536000 + components1.year! * 2629746 + components1.year! * 604800 + components1.year! * 86400 + components1.year! * 3600 + components1.year! * 60 + components1.second!
        
        //        let dateFormatter = DateFormatter()
        //        let tempLocale = dateFormatter.locale // save locale temporarily
        //        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        //        let date = dateFormatter.date(from: dateString)!
        //        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        //        dateFormatter.locale = tempLocale // reset the locale
        //        let dateString = dateFormatter.string(from: date)
        
        //        let calendar = Calendar.current
        //
        //        let year = calendar.component(.year, from: date)
        //        let month = calendar.component(.month, from: date)
        //        let day = calendar.component(.day, from: date)
    }
}


func convertDifferenceDistanceFromDate(dateString: String) -> String {
    if dateString.count == 0 {
        
        return ""
        
    }
    else{
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        dateFormater.locale = Locale(identifier: "en_US_POSIX")
        //dateFormater.timeZone = TimeZone(abbreviation: "IST")
        dateFormater.timeZone = TimeZone(abbreviation: "MST")
        let date = dateFormater.date(from: dateString)!
        
        let dateFormater1 = DateFormatter()
        dateFormater1.dateFormat = "E HH:mm"
        //        dateFormater.locale = Locale(identifier: "en_US_POSIX")
        //dateFormater.timeZone = TimeZone(abbreviation: "GMT")
        dateFormater1.timeZone = TimeZone.current
        //let date1 = dateFormater1.date(from: dateString)!
        
        return dateFormater1.string(from: date)
        //            let currentDate = Date()
        //
        //            let currentTimeZone = TimeZone.current
        //
        //            let nowTimeZone = TimeZone.current
        //
        //            let currentISTOffset = currentTimeZone.secondsFromGMT(for: currentDate)
        //
        //            let nowGMTOffset = nowTimeZone.secondsFromGMT(for: currentDate)
        //
        //            let interval = Double(nowGMTOffset - currentISTOffset) as TimeInterval
        //
        //            let nowDate = Date.init(timeInterval: interval, since: currentDate)
        //
        //            let dateFormaterModified = DateFormatter()
        //            dateFormaterModified.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //            //        dateFormaterModified.locale = Locale(identifier: "en_US_POSIX")
        //            //dateFormaterModified.timeZone = TimeZone(abbreviation: "GMT")
        //            print("bbjnnb=",TimeZone.current)
        //            dateFormaterModified.timeZone = TimeZone.current
        //            //TimeZone.current.identifier
        //            let gregorianCalendar = Calendar.init(identifier: .gregorian)
        //
        //            let components1 = gregorianCalendar.dateComponents([.year, .month,.weekOfMonth, .day, .hour, .minute, .second], from: date, to: nowDate)
        //            if components1.year == 0 {
        //
        //                if components1.month == 0 {
        //
        //                    if components1.weekOfMonth == 0 {
        //
        //                        if components1.day == 0 {
        //
        //                            if components1.hour == 0 {
        //
        //                                if components1.minute == 0 {
        //
        //                                    if components1.second == 0 {
        //
        //                                        return ""
        //
        //                                    }
        //                                    else {
        //                                        return String(describing:abs((components1.second)!)) + " " + "seconds ago"
        //                                    }
        //
        //                                }
        //                                else {
        //                                    return String(describing: abs((components1.minute)!)) + " " + " minutes ago"
        //                                }
        //
        //                            }
        //                            else {
        //                                return String(describing: abs((components1.hour)!)) + " " + "hours ago"
        //                            }
        //
        //                        }
        //                        else {
        //                            return String(describing: abs((components1.day)!)) + " " + "days ago"
        //                        }
        //
        //                    }
        //                    else {
        //                        return String(describing: abs((components1.weekOfMonth)!)) + " " + "weeks ago"
        //                    }
        //
        //                }
        //                else {
        //                    return String(describing: abs((components1.month)!)) + " " + "months ago"
        //                }
        //
        //            }
        //            else {
        //                return String(describing: abs((components1.year)!)) + " " + "years ago"
        //            }
        
        //        let dateFormatter = DateFormatter()
        //        let tempLocale = dateFormatter.locale // save locale temporarily
        //        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        //        let date = dateFormatter.date(from: dateString)!
        //        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        //        dateFormatter.locale = tempLocale // reset the locale
        //        let dateString = dateFormatter.string(from: date)
        
        //        let calendar = Calendar.current
        //
        //        let year = calendar.component(.year, from: date)
        //        let month = calendar.component(.month, from: date)
        //        let day = calendar.component(.day, from: date)
    }
}

func getStringFromDateWithFormat(date: NSDate, format: String) -> String {
    let dateFormatter = getDateFormatterWithFormat(format: format)
    if let dateValue: NSDate = date {
        return dateFormatter.string(from: dateValue as Date)
    }
    return ""
}

func getDateFromStringWithFormat(dateString: String, format: String) -> NSDate? {
    let dateFormatter = getDateFormatterWithFormat(format: format)
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let dateInString: String = dateString {
        return dateFormatter.date(from: dateInString) as! NSDate
    }
}
    

func getYearFromStringWithFormat(dateString: String, format: String) -> String? {
    let dateFormatter = getDateFormatterWithFormat(format: format)
    if let dateInString: String = dateString {
        if dateString == "" || dateString == nil {
            return ""
        }else {
            let date = dateFormatter.date(from: dateInString) as? NSDate
            if date != nil {
                let calendar = Calendar.current
                
                let year = calendar.component(.year, from: date as! Date)
                let month = calendar.component(.month, from: date as! Date)
                let day = calendar.component(.day, from: date as! Date)
                return String(year)
            }else{
                return ""
            }
        }
    }
}

//let date = Date()
//let calendar = Calendar.current

//let year = calendar.component(.year, from: date)
//let month = calendar.component(.month, from: date)
//let day = calendar.component(.day, from: date)

func getCurrentDateString() -> String {
    let formatter = DateFormatter()
    // initially set the format based on your datepicker date / server String
    formatter.dateFormat = "MM/dd/yyyy"
    //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.timeZone = TimeZone(abbreviation: "GMT")
    let myString = formatter.string(from: Date()) // string purpose I add here
    // convert your string to date
    let yourDate = formatter.date(from: myString)
    //then again set the date format whhich type of output you need
    //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.dateFormat = "MM/dd/yyyy"
    // again convert your date to string
    let myStringafd = formatter.string(from: yourDate!)
    
    return myStringafd
}
func getCurrentDateAndTimeString() -> String {
    let formatter = DateFormatter()
    // initially set the format based on your datepicker date / server String
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.timeZone = TimeZone(abbreviation: "IST")
    let myString = formatter.string(from: Date()) // string purpose I add here
    // convert your string to date
    let yourDate = formatter.date(from: myString)
    //then again set the date format whhich type of output you need
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    // again convert your date to string
    let myStringafd = formatter.string(from: yourDate!)
    
    return myStringafd
}

func getDashedDateString(date: String) -> String {
    let myDate = date
    let dateFormat = getDateFormatterWithFormat(format: kFullDateWithTimeZoneOffsetFormat)
    
    let date = dateFormat.date(from: myDate)
    dateFormat.dateFormat =  kYearMonthDayFormat
    var newDate  = ""
    if let date = date {
        newDate =  dateFormat.string(from: date)
    }
    print("newDate:\(newDate)")
    
    return newDate
}

func getDateStringWithSlashForamt(date: String) -> String {
    let myDate = date
    let dateFormat = getDateFormatterWithFormat(format: kFullDateWithTimeZoneOffsetFormat)
    
    let date = dateFormat.date(from: myDate)
    dateFormat.dateFormat =  kMonthDateYearFormat
    var newDate  = ""
    if let date = date {
        newDate =  dateFormat.string(from: date)
    }
    
    
    return newDate
}
    
    func getMonthAndYear(dateString: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM/dd/yyyy"
        
        let dateFormatterPrint = DateFormatter()
        //dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        dateFormatterPrint.dateFormat = "MMM, yyyy"
        
        if let date = dateFormatterGet.date(from: dateString) {
            print(dateFormatterPrint.string(from: date))
            
            return dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
            return ""
        }
    }
    
    func getMonthDateYear(dateString: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM/dd/yyyy"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        //dateFormatterPrint.dateFormat = "MMM, yyyy"
        
        if let date = dateFormatterGet.date(from: dateString) {
            print(dateFormatterPrint.string(from: date))
            
            return dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
            return ""
        }
    }

func getTimelineStringDate(myDate: String) -> String {
    let dateFormat = getDateFormatterWithFormat(format: kFullDateWithTimeZoneOffsetFormat)
    
    let date = dateFormat.date(from: myDate)
    dateFormat.dateFormat =  kMonthDayYearTimeFormat
    var newDate  = ""
    if let date = date {
        newDate =  dateFormat.string(from: date)
        let suffix = daySuffix(date: date as NSDate)
        //newDate = newDate.stringByReplacingOccurrencesOfString(",", withString: suffix + ",")
        newDate = newDate.replacingOccurrences(of: ",", with: suffix + ",")
    }
    return newDate
}

func daySuffix(date: NSDate) -> String {
    let calendar = NSCalendar.current
    let dayOfMonth = calendar.component(.day, from: date as Date)
    switch dayOfMonth {
    case 1, 21, 31: return "st"
    case 2, 22: return "nd"
    case 3, 23: return "rd"
    default: return "th"
    }
}

func dayDateWithDaySuffix(date: NSDate) -> (Int, String) {
    let calendar = NSCalendar.current
    let dayOfMonth = calendar.component(.day, from: date as Date)
    switch dayOfMonth {
    case 1, 21, 31: return (dayOfMonth, "st")
    case 2, 22: return (dayOfMonth, "nd")
    case 3, 23: return (dayOfMonth, "rd")
    default: return (dayOfMonth, "th")
    }
}

}
