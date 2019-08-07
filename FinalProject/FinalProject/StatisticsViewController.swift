//
//  StatisticsViewController.swift
//  FinalProject
//
//  Created by Sonny Huang  on 7/31/19.
//  Copyright © 2019 Harvard University. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var deadcount: UITextField!
    
    @IBOutlet weak var alivecount: UITextField!
    
    @IBOutlet weak var emptycount: UITextField!
    
    @IBOutlet weak var borncount: UITextField!
    
    var engine = Engine.sharedEngineInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deadcount.text = String(engine.grid.totaldiedcount)
        alivecount.text = String(engine.grid.totalalivecount)
        emptycount.text = String(engine.grid.totalemptycount)
        borncount.text = String(engine.grid.totalborncount)
        NotificationCenter.default.addObserver(self, selector: #selector(stats(notified:)), name: Statsrefresh, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        deadcount.text = String(engine.grid.totaldiedcount)
        alivecount.text = String(engine.grid.totalalivecount)
        emptycount.text = String(engine.grid.totalemptycount)
        borncount.text = String(engine.grid.totalborncount)
        borncount.setNeedsDisplay()
        alivecount.setNeedsDisplay()
        emptycount.setNeedsDisplay()
        deadcount.setNeedsDisplay()
        
    }
    @objc func stats(notified: Notification) {
        deadcount.text = String(engine.grid.totaldiedcount)
        alivecount.text = String(engine.grid.totalalivecount)
        emptycount.text = String(engine.grid.totalemptycount)
        borncount.text = String(engine.grid.totalborncount)
        borncount.setNeedsDisplay()
        alivecount.setNeedsDisplay()
        emptycount.setNeedsDisplay()
        deadcount.setNeedsDisplay()
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
