//
//  SecondViewController.swift
//  FinalProject
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController,GridDataSource,EngineDelegate,UITextFieldDelegate {
    
    
    @IBOutlet weak var titletext: UITextField!
    @IBOutlet weak var gridview: XView!
    var grideditor = GridEditorViewController()
    var engine = Engine.sharedEngineInstance
    func engine(didUpdate: Engine) {
        self.gridview.setNeedsDisplay()
    }
    
    var size: GridSize { return engine.grid.size }
    var allPositions: [Position] { return engine.grid.allPositions }
    var cellStates: [[CellState]] {
        get { return engine.grid.cellStates }
        set { engine.grid.cellStates = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gridview.dataSource = engine
        titletext.text = engine.title
        engine.timerFired = { engine in
            self.gridview.setNeedsDisplay()
        }
        Engine.sharedEngineInstance.delegate = self

        engine.refreshPeriod = 0.0
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titletext.text = engine.title
        titletext.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func step(_ sender: UIButton) {
        let placebornbefore = self.engine.grid.totalborncount
        let placediedbefore = self.engine.grid.totaldiedcount
        let placealivebefore = self.engine.grid.totalalivecount
        let placeemptybefore = self.engine.grid.totalemptycount
        self.engine.grid = self.engine.grid.next
        let placebornafter = self.engine.grid.currentborn()
        let placediedafter = self.engine.grid.currentdied()
        let placealiveafter = self.engine.grid.currentalive()
        let placeemptyafter = self.engine.grid.currentempty()
        self.engine.grid.totalborncount = placebornbefore + placebornafter
        self.engine.grid.totaldiedcount = placediedbefore + placediedafter
        self.engine.grid.totalalivecount = placealivebefore + placealiveafter
        self.engine.grid.totalemptycount  = placeemptybefore + placeemptyafter
        self.gridview.setNeedsDisplay()
    }
    
    @IBAction func reset(_ sender: UIButton) {
        let grid = Grid(engine.grid.size)
        engine.grid = grid
        engine.title = nil
        titletext.text = engine.title
        titletext.setNeedsDisplay()
        self.gridview.setNeedsDisplay()
    }
    
    @IBAction func save(_ sender: UIButton) {
        let TableViewNoticationName = Notification.Name(rawValue: "TableviewUpdate")
        let nc = NotificationCenter.default
        engine.title = titletext.text
        let info = ["title": titletext.text!, "grid": engine.grid ] as [String : Any]
        nc.post(name: TableViewNoticationName, object: nil, userInfo:info)
        
    }
}

