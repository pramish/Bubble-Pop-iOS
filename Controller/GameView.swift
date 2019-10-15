import UIKit
import GameKit
//The above are the import statements for UI Elements and game frameworks
class GameView: UIViewController { // This class inherits the methods from UIViewController
    @IBOutlet weak var playingGameTime: UILabel!
    @IBOutlet weak var playingGameScore: UILabel!
    @IBOutlet weak var gamePlayerHIghScore: UILabel!
    //The above labels are for Game Time, Game Score and Game High Score respectively.
    @IBOutlet weak var comboScoreLabel: UILabel!
    var playerName:String = ""
    var gameTime:Int = 0
    var bubbleNumbers = 0
    var maxBubble:UInt32 = 15
    var minBubble:UInt32 = 1
    var gameTimer:Timer!
    var gameScore:Int = 0
    var gameLastPoint = 0
    var gameCombo = 0
    var presentGamePoint:[String:Int] = [:]
    var gamePoint:[String:Int] = [:]
    var gameHighScores:[(key:String,value:Int)] = []
    var gameRandom:GKRandomSource = GKARC4RandomSource()// This is for positioning random bubbles in the screen.
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }
    func startGame(){
        let nilPlayer = UserDefaults.standard.dictionary(forKey: "playerHighScores")
        if nilPlayer == nil{ //This function is used to check if the user data is nill. If nill then label highscore as 0 if not then label the highscore as the player highscore.
            gamePlayerHIghScore.text = "0"
        }
        else{
            let playerGameRecord = UserDefaults.standard.dictionary(forKey: "playerHighScores") as! [String:Int]
            gameHighScores = playerGameRecord.sorted { $0.value > $1.value}//This is sorting the player score in ascending order.
            gamePlayerHIghScore.text = String(gameHighScores[0].value)
        }
        playingGameTime.text = String(gameTime) //This is used to set the timer for the game and decreases by 1
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.counter), userInfo: nil, repeats: true)
        maxBubble = UInt32(bubbleNumbers + 1)
        let bubbleNumber = arc4random_uniform(maxBubble - minBubble) + minBubble
        for _ in 1...bubbleNumber{
            createBubble() //This function will invoke createBubble() function where we are creating random bubbles in the screen.
        }

    }
    @objc func counter(){
        gameTime = gameTime - 1
        playingGameTime.text = String (gameTime) //This will have every time frame of the game.
        for gameView in self.view.subviews{
            if gameView is Bubble{
                gameView.removeFromSuperview() //This function will remove the bubbles after every second. And it does not depends weather the player touches the bubble or not.
            }
        }
        if gameTime == 0{
            gameTimer.invalidate()
            finishGame()
            presentGamePoint = [playerName : gameScore] //This will store the player name and player score in the dictionary format.
            let playerNil = UserDefaults.standard.dictionary(forKey: "playerHighScores") //This will store the data permanently with the help of key called "playerHighScores"
            if playerNil == nil{
                UserDefaults.standard.set(presentGamePoint,forKey: "playerHighScores")
            }
            else{
                gamePoint = UserDefaults.standard.dictionary(forKey: "playerHighScores") as! [String:Int]
                if gamePoint[playerName] != nil {
                    if gamePoint[playerName]! < gameScore{ // checks whether the score is greater than highscore. if so then put that highscore.
                        gamePoint[playerName] = gameScore
                    }
                }
                else {
                    gamePoint[playerName] = gameScore // If the player is new to the game, it will save the data to the database.
                }
                UserDefaults.standard.set(gamePoint, forKey: "playerHighScores")
                //It will update every details of the player from start and end of the app.
            }
        }
        let makeBubbleNumber = arc4random_uniform(maxBubble - minBubble) + minBubble //This will create bubbles in every second as we defined at the top.
        for _ in 1...makeBubbleNumber{
            createBubble()
        }
    }
    func createBubble(){
        var bubblePosition : [Int] = randBubblePosition() // This will get the random position of a bubbles so that it can display the bubbles.
        let xAxis = bubblePosition[0]
        let yAxis = bubblePosition[1]
        let bubble = Bubble(frame: CGRect(x: Double(xAxis), y: Double(yAxis), width: 91, height: 91))
        let bubbleColor = randBubble()
        if bubbleColor == "redball"{
            bubble.points = 1
        }
        if bubbleColor == "pinkball"{
            bubble.points = 2
        }
        if bubbleColor == "greenball"{
            bubble.points = 5
        }
        if bubbleColor == "blueball"{
            bubble.points = 8
        }
        if bubbleColor == "blackball"{
            bubble.points = 10
        }
        // Providing the ball points to their respective bubbles.
        
        let ballImage = UIImage.init(imageLiteralResourceName: bubbleColor)
        bubble.setImage(ballImage, for: UIControl.State.normal) // When creating bubbles, provide respective bubbles image to the bubbles.
        var bubbleLocation = true
        for bubbleView in self.view.subviews{
            if let currentBubble = bubbleView as? Bubble{
                if currentBubble.frame.intersects(bubble.frame){
                    bubbleLocation = false
                    break
                }
            }
        }
        if bubbleLocation {
            bubble.addTarget(self, action: #selector(tapBubble(_:)), for: UIControl.Event.touchUpInside)
            self.view.addSubview(bubble)
            //This is because not to overlap the bubbles when creating randomly and at random position.
        }
    }
    func randBubble() -> String{
        var randBag:[String] = []
        for _ in 1...40{
            randBag.append("redball")
        }
        for _ in 1...30{
            randBag.append("pinkball")
        }
        for _ in 1...15{
            randBag.append("greenball")
        }
        for _ in 1...10{
            randBag.append("blueball")
        }
        for _ in 1...5{
            randBag.append("blackball")
        }
        let bubbleChoice:Int = gameRandom.nextInt(upperBound: randBag.count)
        return randBag[bubbleChoice]
    }
    func randBubblePosition() -> [Int]{
        let xAxis = CGFloat(gameRandom.nextUniform()) * (self.view.frame.width - 101)
        var yAxis = CGFloat(gameRandom.nextUniform()) * (self.view.frame.height - 101)
        if yAxis < 125 {
            yAxis = yAxis + 125
        }
        return [Int(xAxis),Int(yAxis)]
        // Returns the random position of the bubbles and provides to the view.
    }
    @IBAction func tapBubble(_ sender: Bubble){
        let highScores:Int = 0
        if sender.points == gameLastPoint{
            self.gameScore = gameScore + Int(Double(sender.points) * 1.5)
            sender.removeFromSuperview()
            playingGameScore.text = String(gameScore)
            gameLastPoint = sender.points
            gameCombo = gameCombo + 1
            if highScores<gameScore {
                gamePlayerHIghScore.text = String (gameScore)
            }
        }
        else {
            gameCombo = 0
            self.gameScore = gameScore + sender.points
            sender.removeFromSuperview()
            playingGameScore.text = String(gameScore)
            gameLastPoint = sender.points
            if highScores<gameScore {
                gamePlayerHIghScore.text = String (gameScore)
            }
        }
        comboScoreLabel.text = String(gameCombo)
        // When player touches the bubble, the respective score and high scores changes.
    }
    func finishGame(){
        let alert = UIAlertController(title: "Game Over", message: "Please press OK to get the results", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: {action in self.performSegue(withIdentifier: "resultView", sender: self)})
        alert.addAction(action)
        self.present(alert,animated: true)
        // alert the player that game is finished and he must click ok to get the result.
    }
    }
