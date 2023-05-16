//
//  CalendarView.swift
//  CalendarView
//
//  Created by YongHe Yang on 2023/05/15.
//

import UIKit
import SnapKit
class CalendarView: UIView{
    // 日期格式化器
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    
    // 当前显示的日期
       var currentDate: Date = Date() {
           didSet {
               updateCalendar()
           }
       }
    var selectedDate: Date?
    var calendar = Calendar.init(identifier: .gregorian)
    // 获取今天的日期
    var today:Date?;

    // 日历集合视图
    var collectionView: UICollectionView!
    // 头部周数据
    let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let preBtn:UIButton = UIButton(type: .custom);
    let nextBtn:UIButton = UIButton(type: .custom);

    override init(frame: CGRect) {
        super.init(frame: frame);
        setupBgView()
        calendar.timeZone = TimeZone.current;
        selectedDate = calendar.startOfDay(for: Date());
        today = calendar.startOfDay(for: Date());

        // 创建日历集合视图布局
                let layout = UICollectionViewFlowLayout()
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
                
                // 创建日历集合视图
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 360), collectionViewLayout: layout)
                collectionView.dataSource = self
                collectionView.delegate = self
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        collectionView.register(WeekDayHeader.self, forCellWithReuseIdentifier: "WeekDayHeader")

        
            self.addSubview(collectionView)
            
        
                // 更新日历
                updateCalendar()
        initBnt();

    }
    
    func initBnt(){
        self.addSubview(nextBtn);
        self.addSubview(preBtn);
        nextBtn.setTitle("next", for: .normal);
        nextBtn.setTitleColor(UIColor.white, for: .normal);
        nextBtn.backgroundColor = UIColor.blue;
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium);
        
        preBtn.setTitle("pre", for: .normal);
        preBtn.setTitleColor(UIColor.white, for: .normal);
        preBtn.backgroundColor = UIColor.red;
        preBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium);
        
        nextBtn.snp.makeConstraints { make in
            make.left.equalTo(self.snp.centerX).offset(10);
            make.top.equalTo(collectionView.snp.bottom).offset(10);
            make.width.equalTo(80);
            make.height.equalTo(40);
        };
        
        
        preBtn.snp.makeConstraints { make in
            make.right.equalTo(self.snp.centerX).offset(-10);
            make.top.equalTo(collectionView.snp.bottom).offset(10);
            make.width.equalTo(80);
            make.height.equalTo(40);
            
        };
        
        preBtn.addTarget(self, action: #selector(previousMonth), for: .touchUpInside);
        nextBtn.addTarget(self, action: #selector(nextMonth), for: .touchUpInside);

        
        
    }
    
    
    // 更新日历显示
        func updateCalendar() {
            collectionView.reloadData()
        }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBgView() {
        // 设置视图的背景颜色
                backgroundColor = .white
                 
                // 设置边框颜色和宽度
                layer.borderColor = UIColor.white.cgColor
                layer.borderWidth = 1.0
                
                // 设置阴影颜色
                layer.shadowColor = UIColor.black.cgColor
                
                // 设置阴影偏移量和模糊半径
                layer.shadowOffset = CGSize(width: 0, height: 2)
                layer.shadowRadius = 4
                
                // 设置阴影不透明度和路径
                layer.shadowOpacity = 0.3
                layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        
        }
    
    
  
    
    
    // 上一个月
       @objc func previousMonth() {
           currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
       }
       
       // 下一个月
       @objc func nextMonth() {
           currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
       }
       
    

}

class CalendarCell: UICollectionViewCell {
    
    var dayLabel: UILabel!
    override var isSelected: Bool {
          didSet {
              if isSelected {
                  dayLabel.textColor = UIColor.red
              }
          }
      }
    override init(frame: CGRect) {
        super.init(frame: frame)
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        dayLabel = UILabel(frame: contentView.bounds)
        dayLabel.textAlignment = .center
        contentView.addSubview(dayLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class WeekDayHeader:UICollectionViewCell {
    var weekLb: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        weekLb = UILabel(frame: contentView.bounds)
        weekLb.textAlignment = .center
        contentView.addSubview(weekLb)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarView:UICollectionViewDelegate,UICollectionViewDataSource{
       func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 2 // One section for month days, one section for week days
       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           if section == 1 {
               return 42
           } else {
               // Number of week days
               return 7
           }
       }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                   
                   if indexPath.section == 1 {
                       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell

                       // Month days
                       let calendar = Calendar.current
                       let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
                       let weekday = calendar.component(.weekday, from: firstDayOfMonth)
                       let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: currentDate)!.count
                       
                       if indexPath.item >= weekday - 1 && indexPath.item < weekday + numberOfDaysInMonth - 1 {
                           cell.dayLabel.text = "\(indexPath.item - weekday + 2)"
                           let tmpDate:Date =  getDateFromValue(value: cell.dayLabel.text!);
                           let compe:Int = compareOneDay(tmpDate, withAnotherDay: today!);
                           if compe == 1{
                               cell.isUserInteractionEnabled = false
                               cell.dayLabel.textColor = UIColor.lightGray
                           }else{
                               cell.isUserInteractionEnabled = true
                               let res = compareOneDay(tmpDate, withAnotherDay: selectedDate!);
                               if res == 0{
                                   cell.isSelected = true;
                               }else{
                                   cell.isSelected = false;
                                   cell.dayLabel.textColor = UIColor.black;
                               }
                           }

                       } else {
                           cell.dayLabel.text = ""
                       }
                       return cell

                   } else {
                       // Week days
                       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayHeader", for: indexPath) as! WeekDayHeader
                       cell.weekLb.text = weekDays[indexPath.item]
                       cell.weekLb.font = UIFont.boldSystemFont(ofSize: 14)
                       cell.weekLb.textColor = .gray
                       
                       return cell;
                   }
                   
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.width / 7
            let height = collectionView.frame.height / 6
            return CGSize(width: width, height: height)
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarCell {
            selectedDate =  getDateFromValue(value: cell.dayLabel.text!);
           }

        collectionView.reloadData()
    }
    
    //根据字符串获取
    func getDateFromValue(value: String) -> Date{
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        let year = components.year!
        let month = components.month!
        var component = DateComponents()
        component.year = year
        component.month = month
        component.day = 1
        let starteDate = calendar.date(from: components)!
        let resultDate:Date = calendar.date(byAdding: .day, value: Int(value) ?? 1, to: starteDate)!
        
        return resultDate
        
    }
    //比较两个日期大小
    func compareOneDay(_ oneDay: Date, withAnotherDay anotherDay: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let oneDayStr = dateFormatter.string(from: oneDay)
        let anotherDayStr = dateFormatter.string(from: anotherDay)
        guard let dateA = dateFormatter.date(from: oneDayStr), let dateB = dateFormatter.date(from: anotherDayStr) else {
            print("无法解析日期")
            return 0
        }
        let result = dateA.compare(dateB)
        if result == .orderedDescending {
            // date02比date01小
            return 1
        } else if result == .orderedAscending {
            // date02比date01大
            return -1
        }
        // date02和date01是同一天
        return 0
    }
    
}
