import UIKit

class ViewController: UIViewController {
    var password = ""
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }
    
    @IBAction func onBut2(_ sender: Any) {
        let queue = OperationQueue()
        let blockOperationGenPassword = BlockOperation {
            self.generationBruteForce()
            
            OperationQueue.main.addOperation {
                self.textField.text = self.password
            }
        }

        let blockOperationSelectPassword =  BlockOperation {
            OperationQueue.main.addOperation {
                self.activityIndicator.startAnimating()
            }
            
            let password = self.bruteForce(passwordToUnlock: self.password)
            print("selectionPassword: \(password)")
            
            OperationQueue.main.addOperation {
                self.label.text = password
                self.label.textColor = .black
                self.textField.isSecureTextEntry = false
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            }
        }
        blockOperationSelectPassword.addDependency(blockOperationGenPassword)
        
        queue.addOperations([blockOperationGenPassword, blockOperationSelectPassword], waitUntilFinished: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.isSecureTextEntry = true
        activityIndicator.hidesWhenStopped = true
    }
    
    func generationBruteForce() {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
        var index = 0
        
        while index != 12345 {
            self.password  = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            print("\(index): \(self.password)")
            index += 1
        }
    }
    
    func bruteForce(passwordToUnlock: String) -> String {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }

        var password: String = ""

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
    //             Your stuff here
            print(password)
            // Your stuff here
        }
        
        return password
    }
}



extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }



    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index])
                               : Character("")
}

func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var str: String = string

    if str.count <= 0 {
        str.append(characterAt(index: 0, array))
    }
    else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }

    return str
}
