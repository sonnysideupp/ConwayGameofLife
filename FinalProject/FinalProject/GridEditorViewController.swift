//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by Sonny Huang  on 7/31/19.
//  Copyright © 2019 Harvard University. All rights reserved.
//

import UIKit

typealias ConfigurationCallback = (Configuration) -> Void

class GridEditorViewController: UIViewController {

    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var gridView: XView!
    var size: GridSize = (10,10)
    var config: Configuration!{
        didSet
        {
            let max = config.contents?.flatMap{$0}.max() ?? 5
            size = (max*2, max*2)
        }
        
    }
    var callback: ConfigurationCallback?
    var engine: Engine!
    var bigengine: Engine!
    var c: Configuration?
    override func viewDidLoad() {
        super.viewDidLoad()
        bigengine = Engine.sharedEngineInstance
        var grid = Grid(size)
        text.text = config.title
        config.contents?.forEach({
            grid.cellStates[$0[0]][$0[1]] = .alive
            }
        )
        engine = Engine(grid: grid)
        gridView.dataSource = engine
        let s = String(data: try! JSONEncoder().encode(config),encoding: .utf8)
        UserDefaults.standard.set(s, forKey: "Configuration")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: UIButton){
        
        Engine.sharedEngineInstance.grid = self.engine.grid
        Engine.sharedEngineInstance.title = config.title
        Engine.sharedEngineInstance.delegate?.engine(didUpdate: self.engine)
        NotificationCenter.default.post(name: EngineNoticationName, object: nil)
    }
    

    @IBAction func publish(_ sender: UIButton) {
        c = Configuration(
            title: text.text,
            contents: engine.grid.allPositions.filter { engine.grid.cellStates[$0.row][$0.col].isAlive }.map { [$0.row, $0.col] }
        )
        callback?(c!)
        OperationQueue.main.addOperation {
            self.navigationController?.dismiss(animated: true, completion: nil)
    }
        _ = navigationController?.popToRootViewController(animated: true)
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
