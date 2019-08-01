//
//  FirstViewController.swift
//  FinalProject
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {

    @IBOutlet weak var table: UIView!
    private var tableview: ConfigurationTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

    @IBAction func add(_ sender: Any) {
        var grid = Grid((10,10))
        let newconfig = Configuration(title: "newconfig", contents: grid.allPositions.filter { grid.cellStates[$0.row][$0.col].isAlive }.map { [$0.row, $0.col] })
        self.tableview.configs.append(newconfig)
        
    }
    
    
}

