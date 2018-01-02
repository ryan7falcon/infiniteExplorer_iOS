//
//  HighScoreViewController.swift
//  InfiniteExplorer
//
//  Created by Xcode User on 2017-12-27.
//  Author Thomas Irwin
//Purpose is to manage and controll the HighScore view which includes
//A segemented controller and table view in which to view highScores
//The High Scores are stored remotly and are recived by the APi class


import UIKit

class HighScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
    // The Segemented controller which decide which worlds highscore are shown
    @IBOutlet var WorldChooser : UISegmentedControl!
    // The table in whihc the high Scores are shown
    @IBOutlet var HighScoreTable : UITableView!
    //Label for a new Score if the a game was just finished
    @IBOutlet var ScoreLbl : UILabel!
    //Label for the username the user entered for the new score
    @IBOutlet var UserNameLbl : UILabel!
    
    // Used to store the new score to be sent to the Database
    var NewScore : Int!
    // Used to store the world to be sent to the Database
    var NewWorld : Int!
    // Used to store the new name to be sent to the Database
    var NewName : String!
    
    //Instance of APi Class to interact with Remote Database
    let Api = HighScoreApiClass()
    //Timer To help sync
    var timer : Timer!
  
    //This method is used to refersh the data in the table to show the correct information
    @objc func refreshTable(){
        //loads the proper data from the choice in the segemented controller
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
    
    //Changes the Data on a change of the segemented controller
    @IBAction func segmentedControlActionChanged(sender: AnyObject) {
        HighScoreTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NewName = "AAA"
        NewScore = 100001
        NewWorld = 2
      //  Api.PostScore(name:NewName, score:NewScore , world:NewWorld)
        
        
        let ScoreString = String(describing:NewScore!)
        ScoreLbl.text = ScoreString
        UserNameLbl.text = NewName
        //Calls to get both the sets of scores from the remote database
        Api.GetWorld1Scores()
        Api.GetWorld2Scores()
      
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector:  #selector(self.refreshTable), userInfo: nil, repeats: true);
    }
    
    override func viewDidAppear(_ animated: Bool) {
       refreshTable()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
        // Dispose of any resources that can be recreated.
    }
   //Controls the number of sections in the table
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //Tell the table view how many rows in the datasource for the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

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
    
    //Controls the cell and table structure
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //calls the table cell
        let tableCell : HighScoreTableViewCell = tableView.dequeueReusableCell(withIdentifier:"myCell") as? HighScoreTableViewCell ?? HighScoreTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "myCell")
        //gets the proper data from the right datasource
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
