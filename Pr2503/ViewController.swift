import UIKit

class ViewController: UIViewController {
    
    // MARK: - Element
    @IBOutlet weak var generatedPasswordTextField: UITextField!
    @IBOutlet weak var crackedPasswordLabel: UILabel!
    @IBOutlet weak var generatedPasswordButton: UIButton!
    @IBOutlet weak var crackedPasswordButton: UIButton!
    @IBOutlet weak var changeBackgroundButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var lengthPassword = 35
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    private var password = ""
    
    // MARK: - Lifestyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generatedPasswordTextField.isSecureTextEntry = true
        activityIndicator.hidesWhenStopped = true
    }
        
    // MARK: - Action
    
    @IBAction func onChangeBackground(_ sender: Any) {
        isBlack.toggle()
    }
    
    @IBAction func onHackPassword(_ sender: Any) {
        self.activityIndicator.startAnimating()
        let queue = DispatchQueue(label: "queue", qos: .background, attributes: .concurrent)
        var hackPassword = ""
        for i in self.password {
            let dispatchWorkItem = DispatchWorkItem {
                hackPassword.append(self.bruteForce(passwordToUnlock: String(i)))
            }
            queue.asyncAndWait(execute: dispatchWorkItem)
        }
        crackedPasswordLabel.text = hackPassword
        generatedPasswordTextField.isSecureTextEntry = false
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    @IBAction func onGeneratedPssword(_ sender: Any) {
        password = self.generatedPassword()
        generatedPasswordTextField.text = self.password
    }
    
    // MARK: - Private func
    
    func generatedPassword() -> String {
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }
        var password = ""
        for _ in 0...self.lengthPassword {
            password.append(generateBruteForce(ALLOWED_CHARACTERS.randomElement()!, fromArray: ALLOWED_CHARACTERS))
        }
        
        return password
    }
    
    func bruteForce(passwordToUnlock: String) -> String {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }

        var password: String = ""

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
    //           Your stuff here
            print(password)
            // Your stuff here
        }
            
        print(password)
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
