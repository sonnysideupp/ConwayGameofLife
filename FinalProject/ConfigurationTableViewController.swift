//
//  ConfigurationTableViewController.swift
//  FinalProject
//
//  Created by Sonny Huang  on 7/31/19.
//  Copyright © 2019 Harvard University. All rights reserved.
//
import UIKit

class ConfigurationTableViewController: UITableViewController {
    var configs: [Configuration] = []
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Fetcher.fetchRaw(url: Configuration.ConfigurationURL) { (fetched: Result<DataTaskCompletion, String>) in
            let result = fetched
                .flatMap { (result) -> Result<Data, String> in
                    guard let response = result.response as? HTTPURLResponse, result.netError == nil else {
                        return .failure(result.netError!.localizedDescription)
                    }
                    guard response.statusCode == 200 else {
                        return .failure("\(response.description)")
                    }
                    guard let data = result.data else {
                        return .failure("valid response but no data")
                    }
                    return .success(data)
                }
                .flatMap { (data: Data) -> Result<[Configuration], String> in
                    do {
                        let configs = try JSONDecoder().decode([Configuration].self, from: data)
                        return .success(configs)
                    } catch {
                        return .failure(error.localizedDescription)
                    }
            }
            
            switch result {
            case .success(let configs):
                self.configs = configs
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return configs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Configuration", for: indexPath)
        cell.textLabel?.text = configs[indexPath.row].title
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Cancel"
        navigationItem.backBarButtonItem = backItem
        guard let destination = segue.destination as? GridEditorViewController else { return }
        guard let indexPath = self.tableView.indexPathsForSelectedRows?.first else { return }
        destination.config = configs[indexPath.row]
        
        destination.callback = { (configuration) in
            self.configs[indexPath.row] = configuration
            self.tableView.reloadData()
            self.indexPath = nil
        }
     }
 
    
}

