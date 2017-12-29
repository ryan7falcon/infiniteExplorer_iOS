//
//  HighScoreViewController.swift
//  InfiniteExplorer
//
//  Created by Xcode User on 2017-12-27.
//  Copyright © 2017 Ryan Falcon. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
    @IBOutlet var WorldChooser : UISegmentedControl!
    @IBOutlet var HighScoreTable : UITableView!
    
    let Api = HighScoreApiClass()
    var timer : Timer!
    
    @objc func refreshTable(){
        if(WorldChooser.selectedSegmentIndex == 0){
            if (Api.World1Scores?.count)! > 0
            {
                self.HighScoreTable.reloadData()
                self.timer.invalidate()
            }
        }
        if(WorldChooser.selectedSegmentIndex == 1){
            if (Api.World2Scores?.count)! > 0
            {
                self.HighScoreTable.reloadData()
                self.timer.invalidate()
            }
        }
    }
    
    @IBAction func segmentedControlActionChanged(sender: AnyObject) {
        
        HighScoreTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //WorldChooser.addTarget(self,action:"segmentedControlValueChanged",for:.valueChanged)
        // Do any additional setup after loading the view.
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector:  #selector(self.refreshTable), userInfo: nil, repeats: true);
        
        Api.GetWorld1Scores()
        Api.GetWorld2Scores()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
        // Dispose of any resources that can be recreated.
    }
    // step 9 - delete extra table methods and set method below to return 1 table
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // step 10 set number of rows to length of dictionary array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(WorldChooser.selectedSegmentIndex == 0){
            if Api.World1Scores != nil
            {
                return (Api.World1Scores?.count)!
            }
            else
            {
                return 0
            }
        }
        if(WorldChooser.selectedSegmentIndex == 1){
            if Api.World2Scores != nil
            {
            return (Api.World2Scores?.count)!
            }
            else
            {
            return 0
            }
        }
        else{
            return 0
            
        }
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // step 11 - configure cell, then move on to DetailsViewController
        // don't forget cell identifier in sb
        let tableCell : HighScoreTableViewCell = tableView.dequeueReusableCell(withIdentifier:"myCell") as? HighScoreTableViewCell ?? HighScoreTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "myCell")
        if(WorldChooser.selectedSegmentIndex == 0){
            let row = indexPath.row
            let rowData = (Api.World1Scores?[row])! as NSDictionary
            tableCell.lblName.text = rowData["name"] as? String
            let score = rowData["score"] as? Int
            let ScoreString = String(describing:score!)
            tableCell.lblScore.text = ScoreString
        }
        if(WorldChooser.selectedSegmentIndex == 1){
            let row = indexPath.row
            let rowData = (Api.World2Scores?[row])! as NSDictionary
            tableCell.lblName.text = rowData["name"] as? String
            let score = rowData["score"] as? Int
            let ScoreString = String(describing:score!)
            tableCell.lblScore.text = ScoreString
        }
        
        return tableCell
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
