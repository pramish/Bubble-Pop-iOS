import UIKit
class GameSetting: UIViewController {
    @IBOutlet weak var textLabel: UITextField!
    @ IBOutlet weak var startGame: UIButton!
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var bubbleQuantity: UILabel!
    @IBOutlet weak var gameTime: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func gameDuration(_ sender: UISlider) {
            gameTime.text = String(Int(sender.value))
        //game duration slider.
    }
    @IBAction func numberofBubbles(_ sender: UISlider) {
            bubbleQuantity.text = String(Int(sender.value))
        //bubbles quantity slider
    }
    @IBAction func startGame(_ sender: UIButton) {
        //checks if the name field is empty, if it is empty, it will alert the user to enter his/her name.
        if isEmpty(){
            performSegue(withIdentifier: "gameStart", sender: self)
        }
        else{
            let alert = UIAlertController(title: "Name cannot be empty", message: "Please provide your name", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //goes to another view when all the details are fulfilled.
        if segue.identifier == "gameStart"{
            if let gameStart = segue.destination as? GameView{
                    gameStart.playerName = playerName.text!
                    gameStart.gameTime = Int(gameTime.text!)!
                    gameStart.bubbleNumbers = Int (bubbleQuantity.text!)!
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    func isEmpty() -> Bool{
        //checks if the name field is empty, if empty return false and returns true if it is not.
        if playerName.text?.count != 0{
            return true
        }
        return false
    }
}
