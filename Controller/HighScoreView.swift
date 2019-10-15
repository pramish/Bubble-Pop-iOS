import UIKit
class HighScoreView: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//    }
    
    //I used picker view to display the data so I have to implement UIPickerViewDelegate and UIPickerViewDataSource
    
//    @IBOutlet weak var scoreTableView: UITableView!
    var playerGameScore:[String:Int] = [:]
    var playerHighScores: [(key:String, value:Int)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        showHighScore()
//        UserDefaults.standard.removeObject(forKey: "playerHighScores")
//        UserDefaults.standard.synchronize() // This is for testing, this is used for removing all of the stored information from the app.
}
func showHighScore(){
            playerGameScore = UserDefaults.standard.dictionary(forKey: "playerHighScores") as! [String:Int]
            playerHighScores = playerGameScore.sorted { $0.value > $1.value}
    //sorting the highscore for displaying on the pickerview.
    }
    @IBAction func restartGame(_ sender: UIButton) {
        performSegue(withIdentifier: "retryGame", sender: self)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return playerHighScores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(playerHighScores[row].key)                                   \(playerHighScores[row].value)"
        //used for displaying the data into the picker view. The extra space is for making good visual in the screen.
    }
}



