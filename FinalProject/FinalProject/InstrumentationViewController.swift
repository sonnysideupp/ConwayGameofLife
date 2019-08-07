//
//  FirstViewController.swift
//  FinalProject
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {

    @IBOutlet weak var sizeStepper: UIStepper!
    @IBOutlet weak var gridSizeTextField: UITextField!
    @IBOutlet weak var refreshPeriodTextField: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var table: UIView!
    var tableview: ConfigurationTableViewController!
    var engine = Engine.sharedEngineInstance
     let TableViewNoticationName = Notification.Name(rawValue: "TableviewUpdate")
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sizeStepper.value = Double(engine.size.cols)
        gridSizeTextField.text = "\(engine.size.cols)" + " by " + "\(engine.size.rows)"
        NotificationCenter.default.addObserver(self, selector: #selector(table(notified:)), name: TableViewNoticationName, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sizeStepper.value = Double(engine.size.cols)
        gridSizeTextField.text = "\(engine.size.cols)" + " by " + "\(engine.size.rows)"
        gridSizeTextField.setNeedsDisplay()
        
        
    }
    @objc func table(notified: Notification) {
        let notifiedtitle = notified.userInfo?["title"] as! String
        let notifiedgrid = notified.userInfo?["grid"] as! Grid
        let newconfig1 = Configuration(title: notifiedtitle, contents: notifiedgrid.allPositions.filter { notifiedgrid.cellStates[$0.row][$0.col].isAlive }.map { [$0.row, $0.col] })
        self.tableview.configs.append(newconfig1)
        self.tableview.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ConfigurationTableViewController,
            segue.identifier == "EmbedSegue" {
            self.tableview = vc
        }

    }


    @IBAction func changesize(_ sender: UIStepper) {
        let grid = Grid(GridSize(Int(sender.value),Int(sender.value)))
        engine.grid = grid
        engine.title = nil
        gridSizeTextField.text = "\(engine.size.cols)" + " by " + "\(engine.size.rows)"
        gridSizeTextField.setNeedsDisplay()
    }
    
    @IBAction func toggleTimer(_ sender: UISwitch) {
        sender.isOn ? (engine.refreshPeriod = Double(slider.value)) : (engine.refreshPeriod = 0)
   
        
    }
    @IBAction func sliderValueChange(_ sender: UISlider) {
        refreshPeriodTextField.text = "\(sender.value)"
    }
    
    @IBAction func add(_ sender: UIButton) {
            var grid = Grid((10,10))
            let newconfig = Configuration(title: "newconfig", contents: grid.allPositions.filter { grid.cellStates[$0.row][$0.col].isAlive }.map { [$0.row, $0.col] })
            self.tableview.configs.append(newconfig)
            self.tableview.tableView.reloadData()
      
    }
}

