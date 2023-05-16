//
//  ViewController.swift
//  CalendarView
//
//  Created by YongHe Yang on 2023/05/15.
//

import UIKit

class ViewController: UIViewController {
    
    var calenView:CalendarView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calenView = CalendarView.init(frame: CGRect(x: 20, y: 100, width: self.view.bounds.size.width - 40, height: 460));
        
        self.view.addSubview(calenView!);
        
    }


}

